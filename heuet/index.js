/**
 * Created by Administrator on 2015/12/18.
 * 首页js
 */
var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if ('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}








function programCategorys() {
    //首页全部分类
    /*$.ajax({
        type: 'POST',
        url: baseUrl + "http/httpGet",
        data: {url: "tag", parent_id: 86, rows: 9},
        dataType: "JSON",
        success: function (result) {
            if (result.success) {
                var rows = JSON.parse(result.data).rows ;
                $.each(rows, function (index, tag) {
                    var topTagHtml = "<li>" ;
                    topTagHtml += "<a href='/index/search?tag="+tag.id+"'><span>"+tag.name+"</span></a>" ;
                    topTagHtml += "<div class='navcontent'><ul>" ;
                    var children = tag.children ;
                    $.each(children, function (index, childrenTag) {
                        var childrenTagHtml = "<a href='/index/search?tag="+childrenTag.id+"'>"+childrenTag.name+"</a>" ;
                        topTagHtml += childrenTagHtml ;
                    });
                    topTagHtml += "</ul></div>" ;
                    topTagHtml += "</li>" ;
                    $(".navlist").append(topTagHtml) ;
                });

                //首页分类显示/隐藏扩展
                $(".navlist li").hover(function () {
                    $(this).toggleClass('hover');
                    //$(this).addClass('current');
                    $(".navcontent").eq($(this).index()).show();
                }, function () {
                    $(this).toggleClass('hover');
                    $(".navcontent").eq($(this).index()).hide();
                });
            }
        }
    });*/
    //首页分类显示/隐藏扩展
    $(".navlist_li").hover(function () {//.navlist_li a
        //$(this).toggleClass('hover');
        //$(this).addClass('current');
        if(catalogTimeter){
            setTimeout("showNavcontent_ul()",5);
        }
        if(childCatalogTimeter){
            clearTimeout(childCatalogTimeter)
        }
        $(this).addClass('hover');
        var index = $(".navlist_li").index($(this));//$(this).index()
        $(".navcontent_ul").eq(index).show();
        var offset = $(this).offset();
        $("#leftContent").show();
        $("#leftContent").css("left",offset.left+198);
        $("#leftContent").css("top",offset.top);
    }, function () {
        var index = $(".navlist_li").index($(this));//$(this).index()
        catalogTimeter = setTimeout("closeNavcontent_ul("+index+")",5);
    });
    //子分类添加监听
    $(".navcontent_ul").hover(function(){
        if(catalogTimeter){
            clearTimeout(catalogTimeter);
            catalogTimeter = null;
        }
    },function(){
        childCatalogTimeter = setTimeout("closeNavcontent_ul("+$(this).index()+")",5);
    })

}
var catalogTimeter = null;
var childCatalogTimeter = null;
function closeNavcontent_ul(index){
    $(".navlist_li").eq(index).removeClass('hover');

    $(".navcontent_ul").eq(index).hide();
    $("#leftContent").hide();
}
function showNavcontent_ul(){
    $("#leftContent").show();
}

/*暂时不用
//首页图片轮换
function showProgramPosterSlid() {
    //首页图片轮换
    $.ajax({
        type: 'POST',
        url: baseUrl + "http/httpGet",
        data: {url: "resource", sort: "created_at", order: "desc", rows: 5},
        dataType: "JSON",
        success: function (result) {
            if (result.success) {
                var rows = JSON.parse(result.data).rows ;
                $.each(rows, function (index, resource) {
                    var itemHtml = "<li class='slide-item'>" ;
                    itemHtml += "<a href='/program/showProgram?id="+resource.id+"' title='"+resource.name+"' target='blank'>" ;
                    itemHtml += "<img src='"+resource.poster_url+"' alt='"+resource.name+"'>" ;
                    itemHtml += "</a>" ;
                    itemHtml += "<div class='slide-txt'>" ;
                    itemHtml += "<div class='txt_bg'></div>" ;
                    itemHtml += "<a href='/program/showProgram?id="+resource.id+"' target='_blank'>"+resource.name+"</a>" ;
                    itemHtml += "</div>" ;
                    itemHtml += "</li>" ;
                    $(".slide-cont").append(itemHtml) ;
                });

            }
        }
    });
}
*/

//通知公告
function notices() {
    $.ajax({
        type: 'POST',
        url: baseUrl + "http/httpGet",
        data: {url: "information", sort: "created_at", order: "desc", rows: 8,kind:0},
        dataType: "JSON",
        success: function (result) {
            if (result.success) {
                var rows = JSON.parse(result.data).rows ;
                $.each(rows, function (index, notice) {
                    var itemHtml = "<dd>" ;
                    var name = notice.name ;
                    name = cutString(name,24);
                    itemHtml += "<a title='"+notice.name+"' target='_blank' href='/index/noticeShow?id="+notice.information_id+"&kind=0'>"+name+"</a>" ;
                    itemHtml += "<span class='date'></span>" ;
                    itemHtml += "</dd>" ;
                    $("#noticeList").append(itemHtml) ;
                });
            }
        }
    });
}

/**自定义字符串截取*/
function cutString(strSrc, maxLength) { //aotuCutString
    var result = "";
    if (!strSrc){
        result =  ''
    }else{
        //判断字符串长度
        var baseLength = strSrc.length;
        //获取真实长度
        var trueLength = getWordCount(strSrc);
        var chaLength = trueLength - baseLength;
        if(chaLength == 0){  //不存在中文
            if(baseLength>maxLength){
                result = strSrc.substring(0,maxLength) + '...'
            }else {
                result =  strSrc;
            }
        }else {//存在中文
            if(trueLength > maxLength){//是否需要截取
                if(baseLength > maxLength){
                    var newStr = strSrc.substring(0,maxLength);
                    var newTrueLength = getWordCount(newStr);
                    if(newTrueLength>newStr.length){
                        var cutLength = newStr.length - Math.ceil((newTrueLength-newStr.length)/2);
                        result = cutFilter(newStr.substring(0,cutLength),cutLength,maxLength) + '...';
                    }else {
                        result = newStr + '...';
                    }
                } else {
                    var cutLength = baseLength - Math.ceil((trueLength - maxLength)/2);
                    result = cutFilter(strSrc.substring(0,cutLength),cutLength,maxLength) + '...';
                }
            }else{
                result =  strSrc;
            }
        }
    }
    return result;
}

/**
 * 过滤筛选
 * */
function cutFilter(str,cutLength,maxLength){
    var resutlt = "";
    var trueLength = getWordCount(str);
    if(trueLength>maxLength){
        cutLength--;
        var newStr = str.substring(0,cutLength);
        resutlt = cutFilter(newStr,cutLength,maxLength);
    }else {
        resutlt = str;
    }
    return resutlt;
}
function getWordCount(str) {
///获得字符串实际长度，中文2，英文1
///要获得长度的字符串
    var realLength = 0, len = str.length, charCode = -1;
    for (var i = 0; i < len; i++) {
        charCode = str.charCodeAt(i);
        if (charCode >= 0 && charCode <= 128)
            realLength += 1;
        else realLength += 2;
    }
    return realLength;
}
//资源统计截取
function getTotalHandler(count){
    count = count+"";
    return count.length>7?count.substring(0,5)+"...":count;
}

//资源统计-资源总数量
function programTotalCount() {
    var parmts = {};
    parmts.url = "resource/count";

    $.ajax({
        type: 'POST',
        url: baseUrl + "http/httpGet",
        data: parmts,//query/user_uploaded_file_count
        dataType: "JSON",
        success: function (result) {
            if (result.success) {
                var data = JSON.parse(result.data);//.result;
                //var values = data.total;//result.doc + result.audio + result.video ;
                var values = data.total;
                $("#programTotalCount").html(getTotalHandler(values));//getTotalHandler(values)
                $("#programTotalCount").attr("title",values);
            }
        }
    });
}

//资源统计-资源总容量
function programTotalSize() {
    $.ajax({
        type: 'POST',
        url: baseUrl + "http/httpGet",
        data: {url: "storage_svr/stats/disk"},
        dataType: "JSON",
        success: function (result) {
            if (result.success) {
                var res = JSON.parse(result.data) ;
                var count = Math.ceil(res.total_size*100/(1024*1024*1024))/100;
                $("#programTotalSize").html(getTotalHandler(count)) ;
                $("#programTotalSize").attr("title",count);
            }
        }
    });
}

//用户注册总量
function userTotalCount() {
    $.ajax({
        type: 'POST',
        url: baseUrl + "http/httpGet",
        data: {url: "user/count"},
        dataType: "JSON",
        success: function (result) {
            if (result.success) {
                var total = JSON.parse(result.data).user_count ;
                $("#userTotalCount").html(getTotalHandler(total)) ;
                $("#userTotalCount").attr("title",total);
            }
        }
    });
}

//总访问量
function visitCount() {
    $.ajax({
        type: 'POST',
        url: baseUrl + "http/httpGet",
        data: {url: "query/user_login_count"},
        dataType: "JSON",
        success: function (result) {
            if (result.success) {
                var count = JSON.parse(result.data).count;//9347;//
                $("#visitCount").html(getTotalHandler(count)) ;
                $("#visitCount").attr("title",count);
            }
        }
    });
}

/*暂时不用
//最新资源10条
function newestPrograms() {
    $.ajax({
        type: 'POST',
        url: baseUrl + "http/httpGet",
        data: {url: "resource", sort: "created_at", order: "desc", rows: 10},
        dataType: "JSON",
        success: function (result) {
            if (result.success) {
                var rows = JSON.parse(result.data).rows ;
                $.each(rows, function (index, resource) {
                    var itemHtml = "<dd>" ;
                    itemHtml += "<span class='resodiv'>" ;
                    itemHtml += "<a href='/index/showProgram?id="+resource.id+"'>"+resource.name+"</a>" ;
                    itemHtml += "</span>" ;
                    itemHtml += "<span class='resodiv' style='margin-top: 80px;'>" ;
                    itemHtml += "<a href='/index/showProgram?id="+resource.id+"'>"+resource.name+"</a>" ;
                    itemHtml += "</span>" ;
                    itemHtml += "<a href='/index/showProgram?id="+resource.id+"' title='"+resource.name+"' target='blank'>" ;
                    itemHtml += "<img width='180' height='100' src='"+resource.poster_url+"'>" ;
                    itemHtml += "</a>" ;
                    itemHtml += "</dd>" ;
                    $("#newestPrograms").append(itemHtml) ;
                });
            }
        }
    });
}
*/
/**
 * 加载推荐资源
 * */
function  loadLikeResourcesList(){
    if(isLoginParmts==null){
        setTimeout("loadLikeResourcesList()",500);
    }else if(isLoginParmts == true){//加载 推荐资源
        $.ajax({
            type: 'POST',
            url: baseUrl + "http/httpGet",
            data: {url: "query/resources_recommend_to_user?learn_size=25"},
            dataType: "JSON",
            success: function (result) {
                if (result.success) {
                    var rows = JSON.parse(result.data).rows ;
                    var list = [];
                    var list2 = [];
                    list.push('<dt class="dltitle br1"><span class="title">推荐资源</span></dt>');
                    list2.push('<dt class="dltitle"><span class="title">推荐资源</span></dt>');
                    $.each(rows, function (index, item) {
                        if(index < 5){
                            var fileType = checkFileType(item.file_path);
                            var name = cutString(item.name,18);

                            list.push('<dd style="width: 180px;">');
                            var rkind = item.kind+"";
                            if(rkind == "4"){
                                list.push('<a href="/course/courseShow/'+item.id+'?fileType='+fileType+'"');
                                list.push(' title="'+item.name+'" target="blank">');
                            }else if(rkind == "5"){
                                list.push('<a href="/course/courseStaticView/'+item.id+'?fileType='+fileType+'"');
                                list.push(' title="'+item.name+'" target="blank">');
                            }else if(rkind == "6"){
                                list.push('<a href="'+item.description+'" title="'+item.name+'" target="blank">');
                            }else {
                                list.push('<a href="/program/showProgram/'+item.id+'?fileType='+fileType+'"');
                                list.push(' title="'+item.name+'" target="blank">');
                            }
                            list.push('<span class="resodiv1" style="width:180px;"></span>');
                            if(item.poster_url==""){
                                list.push('<img width="180" height="100" src="/skin/front/default/images/default.png?_debugResources=y&n=1457925374646" ');
                                list.push(' onerror="this.src = \'/skin/front/default/images/default.png?_debugResources=y&n=1457925374646\'" alt="'+item.name+'">');
                            }else{
                                list.push('<img width="180" height="100" src="'+item.poster_url+'" ');
                                list.push(' onerror="this.src = \'/skin/front/default/images/default.png?_debugResources=y&n=1457925374646\'" alt="'+item.name+'">');
                            }
                            list.push('<div style="width: 180px; overflow: hidden">');
                            list.push('<div style="float: left; width: 148px; overflow: hidden">'+name+'</div>');
                            list.push('<div  class="score" >0分</div>');
                            list.push('</div>');
                            //list.push('<div style="float: left; width: 148px; overflow: hidden">'+item.user_name+'</div>');
                            //作者
                            list.push('<p class="title" style="margin-top: 5px;">');
                            item.metas.data.author = item.metas.data.author==undefined?null:item.metas.data.author;
                            var author = item.metas.data.author==null?"":item.metas.data.author;
                            list.push('<a href="/program/showProgram/'+item.id+'?fileType='+fileType+'" title="'+item.name+'" target="blank">作者：'+author+'</a>');
                            list.push('</p>');

                            list.push('</div>');
                            list.push('</a>');
                            list.push('</dd>');
                            //底部推送资源
                            list2.push('<dd>');
                            if(rkind == "4"){
                                list2.push('<a href="/course/courseShow/'+item.id+'?fileType='+fileType+'"');
                                list2.push(' title="'+item.name+'" target="blank">');
                            }else if(rkind == "5"){
                                list2.push('<a href="/course/courseStaticView/'+item.id+'?fileType='+fileType+'"');
                                list2.push(' title="'+item.name+'" target="blank">');
                            }else if(rkind == "6"){
                                list2.push('<a href="'+item.description+'" title="'+item.name+'" target="blank">');
                            }else {
                                list2.push('<a href="/program/showProgram/'+item.id+'?fileType='+fileType+'"');
                                list2.push(' title="'+item.name+'" target="blank">');
                            }
                            var cutName = cutString(item.name,24);
                            list2.push(cutName+'</a>');
                            var typeStyle = '';
                            if(fileType=='1'){
                                typeStyle = 'class="w_ico5" style="margin-top: 8px;" ';
                            }else if(fileType=='2'){
                                typeStyle = ' class="w_ico5" style="margin-top: 8px;" ';
                            }else if(fileType=='3'){
                                typeStyle = ' class="w_ico7" style="margin-top: 8px;" ';
                            }else if(fileType=='4'){
                                typeStyle = ' class="w_ico6" style="margin-top: 8px;" ';
                            }else if(fileType=='5'){
                                typeStyle = ' class="w_ico1" ';
                            }else{
                                typeStyle = ' class="w_ico2" style="margin-top:6px;" ';
                            }
                            list2.push('<span '+typeStyle+'></span>');
                            list2.push('</dd>');
                        }
                    });
                    if(rows.length>0){
                        $("#likeResourcesList").html(list.join(""));
                        $('dl[class="inw2 box boxlist3 icnxh"]').html(list2.join(""));
                    }
                }
            }
        });
    }
}

/**
 * 加载课程中心课程
 * */
function courseList(){
    $.ajax({
        type: 'POST',
        url: "http://"+course_ip+":"+course_port+"/TuijianCourse.ashx",
        dataType: "JSON",
        success: function (data) {
            //var couseInfoUrl = "http://"+course_ip+"/web/CourseCenter/MicroLessonCourse.aspx?course_guid=";
            
            var courseInfoUrl = "http://"+course_ip+"/CourseCenter/NewCourseInfo?course_guid=";

            var list = [];
            list.push('<dt class="dltitle br1"><span class="title">课程中心</span><a  href="'+"http://"+course_ip+'/CourseCenter/NewCourseSearch?courseType=hot?userCode='+userName+'&userType=teacher" title="" target="blank" ' +
                ' style="  float: right;  margin-right: 20px;  ">更多&gt;&gt;</a></dt>');
            $.each(data, function (index, item) {
                if(index < 10){
                    var name = cutString(item.course_name,18);

                    list.push('<dd style="width: 180px;">');

                    //list.push('<a href="'+item.course_url+'&userCode='+userName+'"');
                    list.push('<a href="'+courseInfoUrl+''+item.course_guid+'&userCode='+userName+'&userType=teacher"');
                    list.push(' title="'+item.course_name+'" target="blank">');

                    list.push('<span class="resodiv1" style="width:180px;"></span>');
                    if(item.course_image==""){
                        list.push('<img width="180" height="100" src="/skin/front/default/images/default.png?_debugResources=y&n=1457925374646" ');
                        list.push(' onerror="this.src = \'/skin/front/default/images/default.png?_debugResources=y&n=1457925374646\'" alt="'+item.course_name+'">');
                    }else{
                        list.push('<img width="180" height="100" src="'+"http://"+course_ip+''+item.course_image+'"');
                        list.push(' onerror="this.src = \'/skin/front/default/images/default.png?_debugResources=y&n=1457925374646\'" alt="'+item.course_name+'">');
                    }
                    list.push('<div style="width: 180px; overflow: hidden">');
                    list.push('<div style="float: left; width: 148px; overflow: hidden">'+name+'</div>');
                    list.push('<div  class="score" ></div>');
                    list.push('</div>');
                    //作者
                    list.push('<p class="title" style="margin-top: 5px;">');

                    //list.push('<a href="'+item.course_url+'&userCode='+userName+'" title="'+item.user_name+'" target="blank">作者：'+item.user_name+'</a>');
                    list.push('<a href="'+courseInfoUrl+''+item.course_guid+'&userCode='+userName+'&userType=teacher" title="'+item.user_name+'" target="blank">作者：'+item.user_name+'</a>');
                    list.push('</p>');

                    list.push('</div>');
                    list.push('</a>');
                    list.push('</dd>');

                }
            });
            if(data.length>0){
               /* list.push('<dd style="width: 378px;background-color: #f3f3f3;text-align: center;padding-top: 61px;padding-bottom: 61px;">');
                list.push('<a href="'+"http://"+course_ip+'" title="" target="blank" style=" height: 30px; font-size: 16px; color: #3faf0f; ">点击查看更多');
                list.push('<span style="font-weight: bold; font-size: 20px;">&gt&gt&gt</span>')
                list.push('</a>');
                list.push('</dd>');*/

                $("#courseCenterList").html(list.join(""));
            }
        }
    });
}


$(function () {

    programCategorys() ;
    //showProgramPosterSlid() ;
    notices() ;
    programTotalCount() ;
    programTotalSize() ;
    userTotalCount() ;
    visitCount() ;
    //newestPrograms() ;
    loadLikeResourcesList();
    courseList();
});
