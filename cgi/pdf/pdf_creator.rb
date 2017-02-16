require 'pdf/writer'
require 'pdf/simpletable'
require 'color/rgb/metallic'

# Example
############################################################
#    pdf = PDFCreator.new("my.pdf","title_name", "1993/10/25", "Off port of Kashima", 
#      "Collision", "Vessel A sank in the off Kashima ", "Any long string here",
#       "chunkybacon.jpg",["chunkybacon.png","chunkybacon.png"])
#    pdf.create()
class PDFCreator
  attr_accessor :pdf

  SUMMARY_LINES = 25
  SUMMARY_LINE_WIDTH = 120

  def initialize(pdf_name, title_name, issue_date, location, category, subject, str_list,
     map_image, news_images)
    @pdf_name = pdf_name
    @title_name = title_name
    @issue_date = issue_date
    @location = location
    @category = category
    @subject = subject
    @map_image = map_image
    @news_images = news_images
    @str_list = str_list

    @pdf = PDF::Writer.new("A4")
    @pdf.select_font("Helvetica")
    @pdf.stroke_color    Color::RGB::Black
    @pdf.margins_pt(10, 10, 10, 10)
    @pdf.rectangle(20, 10, @pdf.margin_width - 15, @pdf.margin_height - 10).stroke
  end

  def create_table(font_size, title_name,position, width, show_lines, shaded_rows)
    PDF::SimpleTable.new do |tab|
      tab.column_order.push(*%w(colname))
      tab.columns["colname"] = PDF::SimpleTable::Column.new("colname") { |col|
        col.heading = "colname"
      }
      tab.show_lines    = show_lines
      tab.show_headings = false
      tab.orientation   = :center
      tab.position      = position + 2.5
      tab.font_size     = font_size
      tab.width         = width - 15
      tab.shade_rows    = shaded_rows
      data = [{ "colname" => "     " + title_name}]
      tab.data.replace data
      tab.render_on(@pdf)
    end
  end

  def put_image(image, x, y, w, h)
    @pdf.add_image_from_file("#{image}", x, y, w, h)
  end

  def str_to_arr(str)
    arr = []

    str.each_line { |substr|

      substr.chomp!
      length = substr.length

      if length <= SUMMARY_LINE_WIDTH
        arr << substr
      else
        remain = length % SUMMARY_LINE_WIDTH
        substr.scan(/.{#{SUMMARY_LINE_WIDTH}}/).each {|sline| arr << sline}
        arr << substr[(length - remain)...length]
      end
    }
    arr
  end

  def create_line(height)
    @pdf.line(20, @pdf.margin_height - height, @pdf.margin_width - 180, @pdf.margin_height - height).stroke
  end

  def put_news_picture()
    create_table(15, "                                                         Picture", 311, @pdf.margin_width, :all, :shaded)
    #One picture
    if @news_images && @news_images.size == 1
      put_image(@news_images[0], 160, 13, nil, 230)
    end
    #Two pircture
    if @news_images && @news_images.size == 2
      put_image(@news_images[0], 45, 33, nil, 180)
      put_image(@news_images[1], 320, 33, nil, 180)
    end
    #Three picture
    if @news_images && @news_images.size == 3
      put_image(@news_images[0], 100, 130, nil, 115)
      put_image(@news_images[1], 385, 130, nil, 115)
      put_image(@news_images[2], 100, 13, nil, 115)
    end
    #Four picture
    if @news_images && @news_images.size == 4
      put_image(@news_images[0], 100, 130, nil, 115)
      put_image(@news_images[1], 385, 130, nil, 115)
      put_image(@news_images[2], 100, 13, nil, 115)
      put_image(@news_images[3], 385, 13, nil, 115)
    end
  end

  def put_information()
    #issue_date
    @pdf.move_pointer(9)
    create_table(10, "Issue Date:" + "#{@issue_date}", 221, @pdf.margin_width - 180, :none, :none)
    create_line(60)

    #location
    @pdf.move_pointer(9)
    create_table(10, "Location:" + "#{@location}", 221, @pdf.margin_width - 180, :none, :none)
    create_line(85)

    #category
    @pdf.move_pointer(9)
    create_table(10, "Category:" + "#{@category}", 221, @pdf.margin_width - 180, :none, :none)
    create_line(110)

    #subject
    @pdf.move_pointer(9)
    create_table(10, "Subject:" + "#{@subject}", 221, @pdf.margin_width - 180, :none, :none)
  end

  def put_summary()
    arr = str_to_arr(@str_list)
    @pdf.move_pointer(2)
    create_table(15, "                                                         Summary", 311, @pdf.margin_width, :all, :shaded)
    @pdf.move_pointer(2)
    (0..SUMMARY_LINES - 1).each { |i| 
      create_table(8.5, "#{arr[i]}", 311, @pdf.margin_width, :none, :none)
    }
  end

  def create()
    #Move pointer
    @pdf.move_pointer(-50)

    #Title
    create_table(30, "                " + "#{@title_name}", 311, @pdf.margin_width, :all, :shaded)

    #Information
    put_information()

    #Map image
    put_image(@map_image, @pdf.margin_width - 180, @pdf.margin_height - 133, nil, 96)

    #Write Summary
    put_summary()

    #Write news images
    put_news_picture()

    #Save pdf file
    @pdf.save_as(@pdf_name)
  end
end