import numpy as np
import cv2 as cv
import sys
import os
import subprocess


img = cv.imread("images.jpg", cv.IMREAD_GRAYSCALE) # The image pixels have range [0, 255]
img = img/255  # Now the pixels have range [0, 1]
img_list = img.tolist() # We have a list of lists of pixels

result = ""
for row in img_list:
    row_str = [str(p) for p in row]
    result += "[" + ", ".join(row_str) + "],\n"
# print(result)
# print(type(result))
f = open("image-output.txt","w")
f.write(result)

#  removing "["
x = open("image-output.txt" )
s=x.read().replace("[", "" ) 
x.close()
x=open("image-output.txt","w")
x.write(s)
x.close

#  removing "]"
f = open("image-output.txt" )
st=f.read().replace("]", "" ) 
f.close()
f=open("image-output.txt","w")
f.write(st)
f.close

# removing ,
f = open("image-output.txt" )
st=f.read().replace(",", "" ) 
f.close()
f=open("image-output.txt","w")
f.write(st)
f.close

#  function to convert the lines to a list
def Convert(string):
    li = list(string.split(" "))
    return li


dm_f=open("dms.txt","w")
dm_f.truncate(0)
dm_f.close()


# no of columns
file = open('image-output.txt','r' )
ln1 = file.readline()
lst = Convert(ln1) # string to a list
dm_f=open("dms.txt","a")
dta = " " +str(len(lst))
dm_f.write(dta)  # size of list 
print("Total no of elements in a single line",str(len(lst)))
dm_f.close


# no of rows
with open(r"image-output.txt", 'r') as fp:
    lines = len(fp.readlines())
    print('Total Number of lines:', lines)
    file2 = open("dms.txt", "a")  # append mode
    dt = " " + str(lines)
    file2.write(dt)
    file2.close()


# g++ core.cpp -o core && "/Users/jaimitkumarpanchal/Desktop/Project-Visualization/"core
# g++ -std=c++17 -g main.cpp -o main
subprocess.run(["g++","-std=c++17","","core.cpp","-o","core"])
subprocess.run(["./core"])
# f.truncate(0)
