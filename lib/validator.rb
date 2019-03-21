class Validator
  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
    sudoku_formatted = transform_sudoku_string_to_only_numbers_array(@puzzle_string)

    return 'This sudoku is invalid.' if !sudoku_valid?(sudoku_formatted)
    return 'This sudoku is valid, but incomplete.' if sudoku_valid?(sudoku_formatted) && sudoku_incomplete?(sudoku_formatted)
    return 'This sudoku is valid.'
  end

  # Sudoku main tests --------------------------------------

  def array_does_not_have_repeated_elements_except_zero(array)
    array_without_zeroes = array.select { |el| el != 0 }
    array_without_zeroes.uniq.length === array_without_zeroes.length
  end

  def sudoku_valid?(sudoku)
    test_conditions = [test_sudoku_lines(sudoku), test_sudoku_columns(sudoku), test_sudoku_groups(sudoku)]
    !test_conditions.include?(false)
  end

  def sudoku_incomplete?(sudoku)
    sudoku.include?(0)
  end

  # Sudoku validity tests --------------------------------------
  def test_sudoku_lines(sudoku)
    9.times do |test_line|
      line = []
      9.times do |test_inside_line|
        el = 9 * test_line + test_inside_line
        line << sudoku[el]
      end
      return false if !array_does_not_have_repeated_elements_except_zero(line)
    end
    true 
  end

  def test_sudoku_columns(sudoku)
    9.times do |test_col|
      col = []
      9.times do |test_inside_col|
        el = test_col + 9 * test_inside_col
        col << sudoku[el]
      end
      return false if !array_does_not_have_repeated_elements_except_zero(col)
    end
    true 
  end

  def test_sudoku_groups(sudoku)
    square_first_elements = [0, 3, 6, 27, 30, 33, 54, 57, 60]
    square_first_elements.each do |first_el|
      group = []
      3.times do |test_group|
        3.times do |test_inside_group|
          el = first_el + test_group * 9 + test_inside_group
          group << sudoku[el]
        end
      end
      return false if !array_does_not_have_repeated_elements_except_zero(group)
    end
    true 
  end

  # String manipulation and formatting --------------------------------------
  def transform_sudoku_string_to_only_numbers_array(puzzle_string)
    string_without_special_characters = remove_given_characters_from_string(puzzle_string, ["|", "\n", "-", "+", " "])
    turn_string_with_numbers_to_array_of_numbers(string_without_special_characters)
  end
  
  def remove_given_characters_from_string(string, array_of_chars)
    array_of_chars.each do |char|
      string.gsub!(char, '')
    end

    return string
  end

  def turn_string_with_numbers_to_array_of_numbers(string)
    string.split('').map(&:to_i)
  end
end