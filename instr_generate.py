import random
import os
import numpy as np

# Create a list of instructions
instr = []
instr_int = []

# # Randomly generate instructions
# for i in range(0, 3):
#     # Convert the integers to correspondng binary strings
#     rand = random.randint(4, 16)
#     rand_bin = "{0:05b}".format(rand)
#     instr.append(rand_bin)
#     instr_int.append(rand)

# Manually generated instructions
instr_int = [4, 8, 16]

for num in instr_int:
    bin = "{0:05b}".format(num)     
    instr.append(bin)

# End of program character
instr.append("{0:05b}".format(0))
instr_int.append(0)

# Write the program to the file
file = open("instr.txt", "w")
for ins in instr:
    file.write(str(ins) + "\n")
file.close()


if os.path.exists("array_A.txt"):
  os.remove("array_A.txt")

if os.path.exists("array_B.txt"):
  os.remove("array_B.txt")

if os.path.exists("array_C.txt"):
  os.remove("array_C.txt")

# Randomly generate input arrays
for i in instr_int:
    A = np.random.randint(16, size=(4, i))
    B = np.random.randint(16, size=(i, 4))

    C = np.matmul(A, B)

    A_flat = A.flatten()
    A_list = A_flat.tolist()
    A_bin = ["{0:016b}".format(x) for x in A_list]

    B_flat = B.flatten(order="F")
    B_list = B_flat.tolist()
    B_bin = ["{0:016b}".format(x) for x in B_list]

    C_flat = C.flatten()
    C_list = C_flat.tolist()
    C_bin = ["{0:016b}".format(x) for x in C_list]

    file = open("array_A.txt", "a")
    for bin in A_bin:
        file.write(str(bin) + "\n")
    file.close()

    file = open("array_B.txt", "a")
    for bin in B_bin:
        file.write(str(bin) + "\n")
    file.close()

    file = open("array_C.txt", "a")
    for bin in C_bin:
        file.write(str(bin) + "\n")
    file.close()
    
