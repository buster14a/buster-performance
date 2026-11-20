local commands = {"ls >/dev/null","not-to-be-found-command","exit 3","exit 129","kill -s HUP $$","kill -s KILL $$","sh -c 'kill -s HUP $$'","true"}
for _,command in ipairs(commands) do
 local a,b,c=io.popen(command):close()
 local x,y,z=os.execute(command)
 print(command,a,b,c,x,y,z)
end
