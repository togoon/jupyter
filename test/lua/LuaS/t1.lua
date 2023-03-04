

print(os.date("%Y%m%d %X"));




print(0.05);


function toFixed(data, n)                        --设置精度
  local fixData=data;
  if type(data) == 'number' then
	  fixData= string.format('%0.'..n..'f', fixData);
  end
  return fixData;
end


print('--------设置精度------: '..toFixed(123456789.523456789, 0));


