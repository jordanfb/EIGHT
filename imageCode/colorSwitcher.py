from PIL import Image

'''
Takes an image and 2 tuples containing colors, and
switches all instances of the first color to the 
second color.

Returns the adjusted image
'''
def colorReplace(img, oldColor, newColor):
	width, height = img.size;
	# print("Width: "+ str(width) + " Height: " + str(height))
	if max(oldColor) > 255 or max(newColor) > 255:
		print("ERROR: Invalid color options:  Old: {0}   New: {1}".format(oldColor, newColor))
	count = 0
	for i in range(width):
		for j in range(height):
			pixel = (i, j)
			color = img.getpixel(pixel)
			# print(color)
			if isClose(color, oldColor):
				# print("hit")
				count += 1
				img.putpixel(pixel, newColor)
	print("Pixels Changed: " + str(count))
	return img

def isClose(val1, val2):
	tolerence = 20
	if abs(val1[0] - val2[0]) < tolerence and\
	 abs(val1[1] - val2[1]) < tolerence and\
	 abs(val1[2] - val2[2]) < tolerence and\
	 val1[3] > 200:
	 	return True
	return False

def loadColors(file):
	oldColors = []
	newColors = []
	for line in open(file):
		data = line.split()
		oldColor = (int(data[0]), int(data[1]), int(data[2]))
		newColor = (int(data[3]), int(data[4]), int(data[5]))
		oldColors.append(oldColor)
		newColors.append(newColor)
	return oldColors, newColors

def processImage(picture, oldColors, newColors, imgSet):
	img = Image.open(picture)
	for i in range(len(oldColors)):
		img = colorReplace(img, oldColors[i], newColors[i])
	img.save(imgSet + picture[1:])

def loadFiles(file):
	files = []
	for line in open(file):
		files.append(line.strip())
	return files

def main():
	imgSet = "test"
	oldColors, newColors = loadColors("instructions.txt")
	files = loadFiles("files.txt")
	print(files)
	for picture in files:
		processImage(picture, oldColors, newColors, imgSet)


if __name__ == '__main__':
	main()