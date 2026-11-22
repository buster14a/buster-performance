set pagination off
set confirm off
set debuginfod enabled off
break c_preprocessor_impl.c:817
commands
silent
printf "prepared %u %u %u %u\n",from,end,part.token_count,terminal
continue
end
break pp_scan_false_branch
commands
silent
printf "asked %u %u\n",begin,depth
continue
end
break pp_index_line_pages
commands
silent
printf "index %u\n",data->length
continue
end
run
