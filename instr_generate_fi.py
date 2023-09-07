import random
import os
import numpy as np


def decimal_to_fixed_point_binary(number):
    fractional_bits = 8

    # Calculate the number of integer bits required to represent the given number of fractional bits
    integer_bits = 16 - fractional_bits

    # Ensure the number is within the representable range
    max_value = 2 ** (integer_bits - 1) - 2 ** (-fractional_bits)
    min_value = -(2 ** (integer_bits - 1))
    if number > max_value or number < min_value:
        print(number)
        raise ValueError("Number is out of the representable range")

    # Round the number to the nearest representable value
    scaled_number = round(number * (2**fractional_bits))

    # Convert the scaled integer part to binary
    integer_binary = bin(scaled_number & 0xFFFF)[2:].zfill(16)

    # Extract the integer and fractional parts
    integer_part = integer_binary[:-fractional_bits]
    fractional_part = integer_binary[-fractional_bits:]

    # Combine the integer and fractional parts with a decimal point
    fixed_point_binary = f"{integer_part}{fractional_part}"

    return fixed_point_binary


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
    bins = "{0:05b}".format(num)
    instr.append(bins)

# End of program character
instr.append("{0:05b}".format(0))
instr_int.append(0)

# Write the program to the file
file = open("instr.txt", "w")
for ins in instr:
    file.write(str(ins) + "\n")
file.close()

if os.path.exists("array_A_fi.txt"):
    os.remove("array_A_fi.txt")

if os.path.exists("array_B_fi.txt"):
    os.remove("array_B_fi.txt")

if os.path.exists("array_C_fi.txt"):
    os.remove("array_C_fi.txt")

# Randomly generate input arrays
for i in instr_int:
    A = 3 * np.random.random([4, i])
    B = 3 * np.random.random([i, 4])

    C = np.matmul(A, B)

    A_flat = A.flatten()
    A_list = A_flat.tolist()
    A_bin = []

    for item in A_list:
        temp = decimal_to_fixed_point_binary(item)
        A_bin.append(temp)

    B_flat = B.flatten(order="F")
    B_list = B_flat.tolist()
    B_bin = []

    for x in B_list:
        temp = decimal_to_fixed_point_binary(x)
        B_bin.append(temp)

    C_flat = C.flatten()
    C_list = C_flat.tolist()
    C_bin = []

    for x in C_list:
        temp = decimal_to_fixed_point_binary(x)
        C_bin.append(temp)

    file = open("array_A_fi.txt", "a")
    for item in A_bin:
        file.write(str(item) + "\n")
    file.close()

    file = open("array_B_fi.txt", "a")
    for item in B_bin:
        file.write(str(item) + "\n")
    file.close()

    file = open("array_C_fi.txt", "a")
    for item in C_bin:
        file.write(str(item) + "\n")
    file.close()
