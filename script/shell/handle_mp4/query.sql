use rms;
select file_hash,file_path from serial where program_id in (select program_id from program_category_programs where program_category_id=11);
