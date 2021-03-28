#!/usr/bin/env ruby

require 'pp'
require 'base64'

BLOCKS = [
  0x0000..0x01EF,
  0x0300..0x040F
]

WIDTH = 38

output = []
current_row = []

string = ""

File.open('Final Fantasy-GodMode.sav') do |fh|
  fh.each_byte do |byte|
    pos = fh.pos

    if BLOCKS.any? { |b| b.include?(pos) }
      string << byte

      parts = byte.to_s(4).split(//)

      parts.each do |part|
        current_row << part

        if current_row.length == WIDTH
          output << current_row
          current_row = []
        end
      end
    end
  end
end

loop do
  break if current_row.length == WIDTH

  current_row << rand(4)
end

output << current_row

File.open("output.html", "w") do |out|
  out.puts(<<-HTML)
<html lang="en">
  <head>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.14.0/js/all.min.js" defer></script>
    <meta charset="UTF-8">
    <style type="text/css">
body, html {
  background-color: black;
}

table {
  border-radius: 8px;
  border: 6px solid white;
  margin: 16px;
}

table td {
  padding: 8px;
  border: 1px solid white;
}

.value-1 * {
  color: white;
}

.value-2 * {
  color: mediumorchid;
}

.value-3 * {
  color: lime;
}
    </style>
  </head>
  <body>
    <table cellspacing="0">
HTML

  output.each do |row|
    out.puts(<<-HTML)
      <tr>
    HTML

    row.each do |value|
      if value == "0"
        out.puts %{<td class="value-#{value}">&nbsp;</td>}
      else
        out.puts %{<td class="value-#{value}"><i class="fas fa-circle"></i></td>}
      end
    end

    out.puts(<<-HTML)
      </tr>
    HTML
  end

  out.puts(<<-HTML)
    </table>
  </body>
</html>
HTML
end

