# Install https://github.com/drj11/pypng

import png

data = open("vga_draws_tb.txt", "rt").readlines()

rows = []
row  = []
for l in data:
    l = l[:-1]

    for i in range(3):
        if l[i] == "0":
            row.append(0)
        else:
            row.append(255)

    if len(row) == 3*800:
        rows.append(row)
        row = []

#print rows
png.from_array(rows, 'RGB').save("vga_draws_tb.png")

