class UploadedSheet
  def initialize(tmpfile)
    @filename = File.join(Rails.root, 'tmp', "#{Time.new.to_i}.xls")
    FileUtils.cp(tmpfile.path, @filename)
    @sheet = Excel.new(@filename)
    @sheet.default_sheet = @sheet.sheets.first
  end

  def rows
    @rows ||= begin
      rows = []
      (@sheet.first_row..@sheet.last_row).to_a.each do |row_index|
        row = []
        (@sheet.first_column..@sheet.last_column).to_a.each do |col_index|
          cell = @sheet.cell(row_index, col_index)
          row << Iconv.conv('ISO-8859-1', 'utf-8', cell)
        end
        rows << row
      end
      rows
    end
  end

  def destroy
    FileUtils.rm(@filename)
  end
end