module QuickMime
end

class QuickMime::Part < Struct.new(:filename, :body, :content_type)
  def to_s
    <<-PART
Content-Type: #{content_type}; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="#{filename}"

#{body}

    PART
  end
end

class QuickMime::Multipart
  def initialize(parts)
    @parts = parts
    @boundary = SecureRandom.uuid
  end

  def to_s
    body = @parts.map(&:to_s).join(separator)

    head + body + tail
  end

  private

  attr_reader :boundary

  def head
    <<-HEAD
Content-Type: multipart/mixed; boundary="#{boundary}"
MIME-Version: 1.0

--#{boundary}
    HEAD
  end

  def separator
    "--#{boundary}"
  end

  def tail
    "--#{boundary}--"
  end
end
