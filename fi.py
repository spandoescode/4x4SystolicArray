def decimal_to_fixed_point_binary(number):
    fractional_bits = 8

    # Calculate the number of integer bits required to represent the given number of fractional bits
    integer_bits = 16 - fractional_bits

    # Ensure the number is within the representable range
    max_value = 2 ** (integer_bits - 1) - 2 ** (-fractional_bits)
    min_value = -2 ** (integer_bits - 1)
    if number > max_value or number < min_value:
        raise ValueError("Number is out of the representable range")

    # Round the number to the nearest representable value
    scaled_number = round(number * (2 ** fractional_bits))

    # Convert the scaled integer part to binary
    integer_binary = bin(scaled_number & 0xFFFF)[2:].zfill(16)

    # Extract the integer and fractional parts
    integer_part = integer_binary[:-fractional_bits]
    fractional_part = integer_binary[-fractional_bits:]

    # Combine the integer and fractional parts with a decimal point
    fixed_point_binary = f"{integer_part}{fractional_part}"

    return fixed_point_binary

nums = [1.5, 2, 0.26, 0.79, 3, 0.26 * 0.79]
fractional_bits = 8

for decimal_number in nums:
    fixed_point_binary = decimal_to_fixed_point_binary(decimal_number, fractional_bits)
    print(fixed_point_binary)