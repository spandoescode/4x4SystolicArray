import numpy as np

def read_fixed_point_numbers(file_path, stop):
    # Initialize an empty list to store the fixed-point numbers
    fixed_point_numbers = []

    # Initialise a counter
    counter = 1

    # Read the file line by line
    with open(file_path, "r") as file:
        for line in file:
            # Remove leading/trailing whitespace and newline characters
            line = line.strip()

            # Skip lines that start with a forward slash ("/")
            if not line.startswith("/"):
                # Convert the binary string to integer values for integer and fractional parts
                binary_string = line
                integer_part = int(binary_string[:8], 2)
                fractional_part = int(binary_string[8:], 2)

                # Combine the integer and fractional parts to form the fixed-point number
                fixed_point_number = integer_part + fractional_part / 256.0  # 256 = 2^8

                # Append the fixed-point number to the list
                fixed_point_numbers.append(fixed_point_number)

                # If all the non-zero inputs have been read
                if counter == stop:
                    break
                else:
                    counter = counter + 1

    # Convert the list of fixed-point numbers to a NumPy array
    fixed_point_array = np.array(fixed_point_numbers)

    return fixed_point_array


# Function to convert a 5-bit binary string to an integer
def binary_string_to_integer(binary_string):
    return int(binary_string, 2)


# Create an empty list to store the integer values
integers = []

# Read the binary strings from the file and convert them to integers
with open("instr.txt", "r") as file:
    for line in file:
        binary_string = line.strip()  # Remove leading/trailing whitespaces
        if len(binary_string) == 5:
            integer_value = binary_string_to_integer(binary_string)
            integers.append(integer_value)

# Calculate the stop value from the size of the program
stop = (len(integers) - 1) * 16

out_file = "sim_output.txt"
true_file = "array_C_fi.txt"

out_list = read_fixed_point_numbers(out_file, stop)
true_list = read_fixed_point_numbers(true_file, stop)

# Find the error vector and calculate the mean squared quantisation error
error = np.subtract(true_list,out_list)
mse = np.square(error).mean()

print('The error matrix is as follows: ')
print(error)
print('The mean squared error is: ', str(mse))