class ChecklistsPdf < Prawn::Document
  def initialize(checklists, report_name)
    super(top_margin: 70)
    @checklists = checklists
    @report_name = report_name
    report_header
    line_items
  end

  def report_header
    text "Club Manager - #{@report_name}", size: 30, style: :bold
  end

  def line_items
    move_down 20
    table line_item_rows do
      row(0).font_style = :bold
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def line_item_rows
    [["List Name", "Frequency", "Assigned To", "Created By"]] +
    @checklists.map do |checklist|
      [checklist.name, checklist.frequency, checklist.user_full_name, checklist.author_full_name]
    end
  end
end
