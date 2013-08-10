def literal_spaces(line)
  if line.match(/^\s/)
	_, spaces, content = line.match(/^(\s+)([^\n]+)/)[0..2]
	spaces + content.gsub(/\s+/, ' \space ')
  else
    line.gsub(/\s+/, ' \space ')
  end
end

def handle_tabs(spacing)
  spacing.map { |space|
    case space
    when /\t/ then '    '
    else ' '
    end
  }.join('').split('')
end

def indentation(line)
  if line.match(/^\s/)
    line.gsub(/^\s+/, handle_tabs(line.match(/^\s+/)[0].split('')).each_slice(4).to_a.map { |spaces|
      case spaces.length
      when 4 then '\qquad '
      when 3 then '\quad \space '
      when 2 then '\quad '
      else '\space '
      end
    }.join(''))
  else
    line
  end
end

def apply_replaces(base, replaces)
  if replaces.length == 0
	base
  else
    apply_replaces(base.gsub(replaces.first.first, replaces.first.last), replaces[1..-1])  
  end
end

def literal_keywords(line)
  apply_replaces line, [[/lambda/, '\text{lambda}'], [/[a-zA-Z0-9><]+-\S+/, '\text{\0}'], [/#[^\s]+/, '\text{\0}']]
end

STDIN.read.split("\n").each do |line|   
  puts '\\\\& ' + literal_keywords(indentation(literal_spaces(line)))
end