require 'set'
require_relative '../../lib/token/token'

module RMonkey
  class Lexer
    # @param [String] input
    def initialize(input)
      @input = input.tr("\t\r\n", " ").squeeze(" ")
      @position = 0
      @peek_position = 1
      @char = input.length.zero? ? '' : input[0]
    end

    # @return [Token]
    def next_token
      skip_spaces

      case @char
      when '='
        if peek_char == '='
          consume_char
          token = Token.new(TokenType::EQ, '==')
        else
          token = Token.new(TokenType::ASSIGN, '=')
        end
      when '!'
        if peek_char == '='
          consume_char
          token = Token.new(TokenType::NEQ, '!=')
        else
          token = Token.new(TokenType::BANG, '!')
        end
      when '>'
        token = Token.new(TokenType::GT, '>')
      when '<'
        token = Token.new(TokenType::LT, '<')
      when '+'
        token = Token.new(TokenType::PLUS, '+')
      when '-'
        token = Token.new(TokenType::MINUS, '-')
      when '*'
        token = Token.new(TokenType::ASTERISK, '*')
      when '/'
        token = Token.new(TokenType::SLASH, '/')
      when '('
        token = Token.new(TokenType::LPAREN, '(')
      when ')'
        token = Token.new(TokenType::RPAREN, ')')
      when '{'
        token = Token.new(TokenType::LBRACE, '{')
      when '}'
        token = Token.new(TokenType::RBRACE, '}')
      when ','
        token = Token.new(TokenType::COMMA, ',')
      when ';'
        token = Token.new(TokenType::SEMICOLON, ';')
      when /\d/
        token = read_integer
      when /\w/
        token = read_identifier
      when ''
        token = Token.new(TokenType::EOF, '')
      else
        token = Token.new(TokenType::ILLEGAL, '')
      end

      consume_char
      token
    end

    private

    def consume_char
      @position += 1
      @peek_position += 1

      @char = @position >= @input.length ? '' : @input[@position]
    end

    def peek_char
      @peek_position >= @input.length ? '' : @input[@peek_position]
    end

    def skip_spaces
      consume_char while @char == " "
    end

    def read_integer
      start = @position
      consume_char while peek_char.match(/\d/)

      Token.new(TokenType::INT, @input[start..@position])
    end

    def read_identifier
      start = @position
      consume_char while peek_char.match(/\w/)

      literal = @input[start..@position]
      type = TokenType.from(literal)

      Token.new(type, @input[start..@position])
    end
  end
end
