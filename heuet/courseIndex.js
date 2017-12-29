/**
 * Created by Administrator on 2015/12/18.
 * 首页js
 */
var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var libIndex = localObj.pathname.split("/")[3];
var baseUrl = '';
if ('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}
/**获取url中的参数*/
function GetRequest() {
    var url = localObj.search; //获取url中"?"符后的字串
    var theRequest = {};
    if (url.indexOf("?") != -1) {
        var str = url.substr(1);
        strs = str.split("&");
        for(var i = 0; i < strs.length; i ++) {
            theRequest[strs[i].split("=")[0]]=unescape(strs[i].split("=")[1]);
        }
    }
    return theRequest;
}
//
var getRequest = null;
var childIndex = libIndex;//单位id
var kindIndex = 66;
var librarysData = [];
var search_sort = '';
var libraryIds = [libIndex];

jQuery(document).ready(function ($){
    setNowPath("教学资源");
    getRequest = new GetRequest();
    kindIndex = getRequest["childId"] || 66;
    var resourceLibraryId = '';
    resourceLibraryId = getRequest["resourceLibraryId"];
    if(resourceLibraryId!='' &&　resourceLibraryId!=undefined){
        libraryIds = [resourceLibraryId];
    }
    loadLibrary();//
    if(kindIndex==66){
        changeCourse("bb");
        getCourseList();
    }else{
        //loadResources();
		loadResourceByKind(6);
    }
    loadMenu();
});

function courseIndex(id,levelId, level) {
    if(level == 1) {
        location.href = baseUrl + "course/courseIndex/" + id ;
    }
    else {
        location.href = baseUrl + "course/courseIndex/"+id+"?childId=" + levelId ;
    }
}

/**
 * id:课程库顶级id
 * levelId：课程子库id
 * kind：课程类型 4-视频公开课 5-资源共享课 6-精品课程
 * */
function courseIndex2(id,levelId, kind) {
    //location.href = baseUrl + "course/courseIndex/"+id+"?childId=" + levelId + "&kind=" + kind ;
    childIndex = levelId;
    libraryIds = getTopLibs(librarysData,childIndex);
    loadResources();
}
/**
 * id:课程库顶级id
 * levelId：课程子库id
 * kind：课程类型 4-视频公开课 5-资源共享课 6-精品课程
 * */
function courseIndex3(id,levelId, kind) {
    //location.href = baseUrl + "course/courseIndex/"+id+"?childId=" + levelId + "&kind=" + kind ;
    childIndex = levelId;
    libraryIds = [levelId];
    loadResources();
}
/**按类型加载资源*/
function  loadResourceByKind(kind){
    kindIndex = kind;
    laodParmtsList();//加载
    if(kindIndex==66){
        changeCourse("bb");
        getCourseList();
    }else{
        loadResources();
    }
}
/**设置排序方式*/
function getCondition(sort) {
    /* $("input[name='sort']").val(sort) ;
     $("#courseForm").submit() ;*/
    search_sort = sort;
    loadResources();
}
/**统计资源个数*/
function getResources(data){
    var count = FilterFileStatus(data.resources);
    $(data.children).each(function(index,item){
        count += getResources(item);
    });
    return count;
}
/**过滤筛选*/
function FilterFileStatus(list){
    var countT = 0;
    $(list).each(function(index,item){
        if(item.file_status=='14'){
            countT++;
        }
    });
    return countT;
}

/**筛选资源库id*/
function getTopLibs(data,parentId){
    var ids = [];
    $(data).each(function(index,item){
        if(item.id == parentId){
            ids.push(item.id);
            ids = ids.concat(getLibIds(item.children));
        }
    });
    return ids;
}
function  getLibIds(data){
    var ids = [];
    $(data).each(function(index,item){
        ids.push(item.id);
        ids = ids.concat(getLibIds(item.children));
    });
    return ids;
}
/**获取资源库名称*/
function getLibName(data,parentId){
    var name = "";
    $(data).each(function(index,item){
        if(item.id == parentId){
            name = item.name;
        }else{
            var lname = getLibName(item.children,parentId);
            if(lname!=""){
                name = lname;
            }
        }
    });
    return name;
}

/**
 * 获取检索单位信息
 * */
function loadLibrary(){
    //http://42.62.77.189:3000/resourcelibrary?parent_id=101
    $.post(baseUrl + "http/httpGet",  {url: "resourcelibrary",parent_id:libIndex},
        function(result){
            if(result && result.success){
                var data = JSON.parse(result.data);
                librarysData = data.rows;//保存资源文档信息
                var classCount = 0;
                var listA = [];
                listA.push("<span>按单位检索：</span>");
                var aDiv = '<a class="cs_class_li_a_click" unit="unit_lib_'+libIndex+'" onclick="courseIndex3('+libIndex+','+libIndex+','+kindIndex+')"> 全部 </a>';//（'+count+'）
                listA.push(aDiv);
                $(data.rows).each(function(index,item){
                    var classStyle = "";
                    if (getRequest["resourceLibraryId"] == item.id){
                        classStyle = ' class="active" ';
                        childIndex = item.id;
                    }
                    //var count = getResources(item);
                    //classCount += count;
                    var aDiv = '<a unit="unit_lib_'+item.id+'"  onclick="courseIndex2('+libIndex+','+item.id+','+kindIndex+')">'+item.name+'</a>';//（'+count+'）
                    listA.push(aDiv);

                });
                $("#searchUnitList").html(listA.join(""));
                $("#classCount").html(classCount);
                setTimeout('loadClassCount()',500);
                addLiAClick();
            }
        }, "json");
}
/**同步加载*/
function httpGetCount(parmts){
    var html = jQuery.ajax({
        url: "/http/httpGet",
        data:parmts,
        async: false
    }).responseText;
    var result =  JSON.parse(html);
    var data = JSON.parse(result.data);
    return data.total;
}

function loadClassCount(){
    var parmts =  {url:"resource",parent_id:0,library_ids:libIndex,page:1,rows:r_items_per_page,status:"0,1,2,3",file_status:'14',kind:'4'};
    var count = httpGetCount(parmts);
    var parmts1 =  {url:"resource",parent_id:0,library_ids:libIndex,page:1,rows:r_items_per_page,status:"0,1,2,3",file_status:'14',kind:'5'};
    var count1 = httpGetCount(parmts1);
    var parmts2 =  {url:"resource",parent_id:0,library_ids:libIndex,page:1,rows:r_items_per_page,status:"0,1,2,3",kind:'6'};
    var count2 = httpGetCount(parmts2);
    var sumCount = count + count1 + count2;
    $("#classCount").html(sumCount);
}

function addLiAClick(){
    $('#searchUnitList a').unbind('click').click(function(event){
        var el = event.target || event.srcElement;
        $('#searchUnitList a').removeClass('cs_class_li_a_click');
        $(el).addClass('cs_class_li_a_click');
    });
    $('#searchUnitList a').removeClass('cs_class_li_a_click');
    if(getRequest["resourceLibraryId"]!=undefined){
        $('a[unit="unit_lib_'+ getRequest["resourceLibraryId"]+'"]').addClass('cs_class_li_a_click');
    }else {
        $('a[unit="unit_lib_'+ libIndex+'"]').addClass('cs_class_li_a_click');
    }
}

/**加载菜单列表*/
function loadMenu(){
    //加载列表
    var menuList = [];
   /* menuList.push('<li onclick="loadResourceByKind(4)" name="course_c_menu" class="default menu_ul_li_click" >视频公开课</li>');
    menuList.push('<li onclick="loadResourceByKind(5)" name="course_c_menu" class="default" >资源共享课</li>');*/
    var aHref = bb_server_url+'/webapps/login?userName='+userName+'&url='+'/webapps/portal/frameset.jsp&verify='+verify+'&strSysDatetime='+strSysDatetime+'&jsName='+jsName;
    var bbHref = bb_server_url+'/webapps/login?userName='+userName+'&url='+'web/CourseCenter/CouresCenterHome.aspx';

    menuList.push('<li name="course_c_menu" class="default_edit"  style="text-align: center;"><a  href="javascript:void(0)" onclick="toCourseCenter()" >' +
        '<img src="/images/bbcourse.jpg" style="width: 38px;height: 30px;vertical-align: middle;"/><br/><span>课程中心</span></a> </li>');

    menuList.push('<li class="default_edit" style="text-align: center;"><a target="_blank" href="'+aHref+'" >' +
        '<img src="/images/inbb.png" style="width: 38px;height: 30px;vertical-align: middle;"/><br/><span>网络教学平台</span> </a></li>');

    menuList.push('<li name="course_c_menu" class="default_edit menu_ul_li_click_edit"  style="text-align: center;">' +
        '<a href="javascript:void(0)" onclick="loadResourceByKind(66)" >' +
        '<img src="/images/3.jpg" style="width: 38px;height: 30px;vertical-align: middle;"/><br/><span>B B课程</span></a></li>');

    menuList.push('<li name="course_c_menu" class="default_edit" style="text-align: center;">' +
        '<a href="javascript:void(0)" onclick="loadResourceByKind(6)" >' +
        '<img src="/images/4.jpg" style="width: 38px;height: 30px;vertical-align: middle;"/><br/>' +
        '<span>经贸大学精品课</span></a></li>');

    //http//wlkt1.heuet.edu.cn/webapps/login?userName=201222714&url=http://wlkt1.heuet.edu.cn/webapps/portal/frameset.jsp&verify=732ABAD00E8E6A5740D76B90E5D5916E&strSysDatetime=2016-06-2915:35:26&jsName=teacher

    $("#classMeun").html(menuList.join(""));
    addMenuClickE();
}

function addMenuClickE(){
    /*$('li[name="course_c_menu"]').unbind('click').click(function(event){
        var el = event.target || event.srcElement;
        $('li[name="course_c_menu"]').removeClass('menu_ul_li_click');
        $(el).addClass('menu_ul_li_click');
    })*/
    $('li[name="course_c_menu"]').unbind('mouseover').bind('mouseover',function(event){
        var el = event.target || event.srcElement;
        $('li[name="course_c_menu"]').removeClass('menu_ul_li_click_edit');
        $(el).addClass('menu_ul_li_click_edit');
        var liText = $(el).text();
        if(liText == '视频公开课'){
            loadResourceByKind(4);
        }else if(liText == '资源共享课'){
            loadResourceByKind(5);
        }else if(liText == '精品课程'){
            loadResourceByKind(6);
        }else if(liText == 'B B 课程'){
            loadResourceByKind(66);
        }
    })
}

/**
 * 课程信息
 * */
function toCourseCenter(){
    jQuery.getJSON("/index/getCourseInfo",{},function(result) {
        if (result != null) {
            // window.open("http://"+result.ip+"/CourseCenter/NewCourseSearch?courseType=hot?userCode="+userName,"_blank");
            window.open("http://kczx.heuet.edu.cn/CourseCenter/NewCourseSearch?courseType=hot?userCode="+userName+"&userType=teacher","_blank");
        }
    });
}

/**加载本站资源筛选条件*/
function laodParmtsList(){
    var list = [];
    if(kindIndex == 66){

    }else if(kindIndex != 6){
        /*list.push('<li onclick="getCondition(\'recommend_number\')" style="border-right: none" >推荐</li>');
        list.push('<li onclick="getCondition(\'click_number\')" >最热</li>');
        list.push('<li onclick="getCondition(\'created_at\')" >最新</li>');*/
    }else{
        search_sort = "";
    }
    $("#listParmts").html(list.join(""));
}
var r_items_per_page = 12;
/**加载资源列表*/
function loadResources(){
    var parmts =  {url:"resource",parent_id:0,library_ids:libraryIds.join(),page:1,rows:r_items_per_page,status:"0,1,2,3"};
    if(search_sort!=""){
        parmts.sort = search_sort;
    }
    parmts.kind = kindIndex;
    if(kindIndex!=6){
        parmts.file_status = "14";
    }
    $.post("/http/httpGet",parmts,function(result){
        if(result.success==true){
            var data = JSON.parse(result.data);
            if(kindIndex == 6){
                loadGood(data.rows)
            }else {
                loadShareAndPublic(data.rows);
            }
            var html = [];
            $('#PaginationCount').html('共 '+data.total+' 条记录');
            $("#Pagination").pagination(data.total, {
                num_edge_entries: 1, //边缘页数
                num_display_entries: 5, //主体页数
                prev_text:'上一页',
                next_text:'下一页',
                callback: pageselectCallback,
                items_per_page:r_items_per_page //每页显示20条
            });
        }else{
        }
    });
}
/**分页回调*/
function pageselectCallback(page_index, jq){
    var parmts =  {url:"resource",parent_id:0,library_ids:libraryIds.join(),page:page_index+1,rows:r_items_per_page,status:"0,1,2,3"};
    if(search_sort!=""){
        parmts.sort = search_sort;
    }
    parmts.kind = kindIndex;
    if(kindIndex!=6){
        parmts.file_status = "14";
    }
    $.post("/http/httpGet",parmts,function(result){
        if(result.success==true){
            var data = JSON.parse(result.data);
            if(kindIndex == 6){
                loadGood(data.rows)
            }else {
                loadShareAndPublic(data.rows);
            }

        }else{
        }
    });
}
/**切换列表*/
function changeCourse(listName){
    if(listName == "jpcourse_list"){
        $(".jpcourse_list").show();
        $(".course_list").hide();
        $(".bb_list").hide();
    }else if(listName == "course_list"){
        $(".jpcourse_list").hide();
        $(".course_list").show();
        $(".bb_list").hide();
    }else if(listName == "bb"){
        $(".jpcourse_list").hide();
        $(".course_list").hide();
        $(".bb_list").show();
    }
}

/**加载共享课&公开课列表*/
function loadShareAndPublic(data){
    var list = [];
    $(data).each(function(index,item){
        var nname = cutString(item.name,32);
        //循环
        list.push('<dd>');
        list.push('<div class="lpic">');
        if(item.kind == 4){
            list.push('<a  href="/course/courseShow/'+item.id+'" target="_blank">');
        }else {
            list.push('<a  href="/course/courseStaticView/'+item.id+'" target="_blank">');
        }
        if(item.poster_url != ""){
            list.push('<img src="'+item.poster_url+'" onerror="this.src = \'/skin/front/default/images/default.png\'" alt="'+item.name+'">');
        }else{
            list.push('<img src="/skin/front/default/images/default.png" alt="'+item.name+'">');
        }
        list.push('</a></div>');

        list.push('<p class="title">');
        if(item.kind == 4){
            list.push('<a  href="/course/courseShow/" target="_blank"></a>');
        }else {
            list.push('<a  href="/course/courseStaticView" target="_blank"></a>');
        }
        list.push('</p>');
        list.push('<p class="fl">');
        list.push('<span class="css1">');
        list.push('<span class="w_ico23"></span>');
        list.push(item.recommend_number);
        list.push('</span>');
        list.push('<span class="css2">');
        list.push(' <span class="w_ico30"></span>');
        list.push(item.click_number);//获取评论信息 --${getProgramCommentTotal(id: program.id.toString())}
        list.push('</span>');
        list.push('<span class="css3">'+item.children.length+'</span>');//${applicationContext.programService.getChildrenPrograms(program.children.toString()).size() + 1}
        list.push('</p></dd>');
    });

    //$(".jpcourse_list").hide();
    //$(".course_list").show();
    changeCourse("course_list");
    $(".course_list").html(list.join(""));
}
/**加载精品课列表*/
function loadGood(data){
    var list = [];
    $(data).each(function(index,item){
        //循环
        list.push('<tr>');
        list.push('<td>');
        list.push('<img class="jpimg" src="'+item.poster_url+'"/>');
        list.push('<a href="'+item.description+'" target="_blank">'+item.name+'</a>');
        list.push('</td>');
        var yearStr = item.metas.data.year==null?'':item.metas.data.year;
        list.push('<td>'+yearStr+'</td>');
        list.push('<td>'+getLibName(librarysData,item.resourcelibrary_id)+'</td>');
        var chargeStr = item.metas.data.charge==null?'':item.metas.data.charge;
        list.push('<td>'+chargeStr+'</td>');
        list.push('</tr>');
    });
    //$(".course_list").hide();
    //$(".jpcourse_list").show();
    changeCourse("jpcourse_list");
    $("#jpcourse_list").html(list.join(""));

}











