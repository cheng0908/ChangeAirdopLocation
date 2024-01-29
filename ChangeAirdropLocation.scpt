property AIRDROP_FOLDER : "/Users/chengchristopher/Google Drive/My Drive/Mac_sync_folder/main_syns_fiolder/Airdrop" # Replace your folder path here
property QUARANTINE_KEY : "59"

property GET_QUARANTINE_COMMAND_START : "ls -l -@ '"
property GET_QUARANTINE_COMMAND_END : "' | tr '\\n' ' ' | sed 's/.*com\\.apple\\.quarantine\\s*\\(\\d*\\)/ \\1/' | awk '{$1=$1};1'"

on adding folder items to this_folder after receiving added_items
    repeat with i from 1 to length of added_items
        set current_item to item i of added_items
        try
            set quarantine_type to getQuarantineType(POSIX path of current_item)
            if quarantine_type is equal to QUARANTINE_KEY then
                moveFile(current_item, AIRDROP_FOLDER)
            end if
        on error errMsg
            display dialog "Airdrop scpt error: " & errMsg buttons {"OK"} default button "OK"
        end try
    end repeat
end adding folder items to

on moveFile(move_file, destination_folder_alias)
    try
        set posix_move_file to POSIX path of move_file
        set posix_destination_folder to POSIX path of destination_folder_alias
        do shell script "mv " & quoted form of posix_move_file & " " & quoted form of posix_destination_folder
    on error errMsg
        display dialog "Airdrop scpt error: " & errMsg buttons {"OK"} default button "OK"
    end try
end moveFile

on getQuarantineType(file_path)
    try
        return do shell script GET_QUARANTINE_COMMAND_START & file_path & GET_QUARANTINE_COMMAND_END
    on error errMsg
        display dialog "Airdrop scpt error: " & errMsg buttons {"OK"} default button "OK"
        return "" -- You may want to return a default value or handle the error accordingly
    end try
end getQuarantineType
