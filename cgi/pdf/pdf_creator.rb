require 'pdf/writer'
require 'pdf/simpletable'
require 'color/rgb/metallic'

# Example
############################################################
#    pdf = PDFCreator.new("my.pdf","1993/10/25", "Off port of Kashima", 
#      "Collision", "Vessel A sank in the off Kashima ", "Any long string here",
#       "chunkybacon.jpg",["chunkybacon.png","chunkybacon.png"])
#    pdf.create()
class PDFCreator
  SUMMARY_LINES = 15
  SUMMARY_LINE_WIDTH = 120

  def initialize(pdf_name, issue_date, location, category, subject, str_list,
     map_image, news_images)
    @pdf_name = pdf_name
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
    @pdf.rectangle(25, 25, @pdf.margin_width + 25, @pdf.margin_height).stroke
  end

  def create_table(font_size, title_name, show_lines, shaded_rows)
      PDF::SimpleTable.new do |tab|
      tab.column_order.push(*%w(colname))
      tab.columns["colname"] = PDF::SimpleTable::Column.new("colname") { |col|
        col.heading = "colname"
      }
      tab.show_lines    = show_lines
      tab.show_headings = false 
      tab.orientation   = :center
      tab.position      = 313
      tab.font_size     = font_size
      tab.width         = @pdf.margin_width + 25
      tab.shade_rows    = shaded_rows
      data = [{ "colname" => "     " + title_name}]
      tab.data.replace data
      tab.render_on(@pdf)
    end
  end

  def print_brief_info(info, line_no, offset_height) 
    @pdf.move_pointer(16)
    @pdf.text "#{info}", :font_size => 10, :justification => :left
    @pdf.move_pointer(8)
    height = line_no * 35 + offset_height
    @pdf.line(25, @pdf.margin_height - height, @pdf.margin_width - 180, @pdf.margin_height - height).stroke
  end

  def create_line()
    @pdf.move_pointer(6)
    text = "Issue Date:" + "#{@issue_date}"
    print_brief_info(text, 1, 30)

    #location
    text = "Location:" + "#{@location}"
    print_brief_info(text, 2, 30)

    #category
    text = "Category:" + "#{@category}"
    print_brief_info(text, 3, 30)

    #subject
    text = "Subject:" + "#{@subject}"
    print_brief_info(text, 4, 30)
  end

  def put_image(image, x, y, h)
    @pdf.add_image_from_file("#{image}", x, y, @pdf.margin_width - 275, h)
  end

  def str_to_arr(str)
    arr = []
    s = []
    j = 0

    str.each(separator=$/) { |substr| str_arr = substr

      str1 = ""
      i = 0
      str_arr.chomp!
      j = j + 1
      if str_arr.count(str_arr) > SUMMARY_LINE_WIDTH

        str_arr.each_byte { |x| s<<"%c"%x

          if i == NO
            i = 0
            j = j + 1
            str1 = ""
          end

          str1 = str1 + s.to_s
          arr[j] = str1
          i = i + 1
          s = []
        }

      else
        arr[j] = str_arr
      end
    }
    arr
  end

  def create()
    #Title
    create_table(40, "  MOL Incident News", :all, :shaded)

    #Information 
    create_line()

    #Map image
    put_image(@map_image, @pdf.margin_width - 215, @pdf.margin_height - 171,150)

    #Summary
    arr = str_to_arr(@str_list)
    create_table(25, "                       Summary", :all, :shaded)
    (1..SUMMARY_LINES).each { |i| 
      create_table(8,  "#{arr[i]}", :none, :none)
    }

    #Write news images
    create_table(25, "                       Picture",:all,:shaded)
    put_image(@news_image[0], 40, 25, 130) if @news_image && @news_image.size > 0 
    put_image(@news_image[1], 315, 25, 130) if @news_image && @news_image.size > 1
    put_image(@news_image[2], 40, 160, 130) if @news_image && @news_image.size > 2
    put_image(@news_image[3], 315, 160, 130) if @news_image && @news_image.size > 3

    #Save pdf file
    File.delete(@pdf_name) if File.exists(@pdf_name)
    @pdf.save_as(@pdf_name)
  end
end
