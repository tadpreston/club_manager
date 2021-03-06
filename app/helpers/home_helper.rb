module HomeHelper

  def day_name(day)
    day_name = case day
    when 1 then "Sunday"
    when 2 then "Monday"
    when 3 then "Tuesday"
    when 4 then "Wednesday"
    when 5 then "Thursday"
    when 6 then "Friday"
    when 7 then "Saturday" 
    end

    day_name
  end

  def agenda_items(items, dow)

    item_tags = ''

    items.each do |item|

      if item[:start_at].wday + 1 <= dow && item[:end_at].wday + 1 >= dow

        agenda_time = item[:agenda_time].blank? ? Time.zone.parse('7am') : item[:agenda_time].in_time_zone

        start_hour = item[:type] == 'task' ? '16' : agenda_time.hour
        start_minute = item[:type] == 'task' ? '00' : agenda_time.min
        end_hour = item[:type] == 'task' ? '17' : agenda_time.hour + 1.hour
        end_minute = item[:type] == 'task' ? '00' : agenda_time.min

        item_tags << agenda_span(start_hour,start_minute,end_hour,end_minute,item[:type]) do |tag|
          tag << time_tag(agenda_time, agenda_time,item[:type])
          tag << (item[:type] == 'task' ? 'Task - ' : '') << item[:title]
        end

      end # end if

    end # end agenda_items.each

    item_tags.html_safe

  end

  def agenda_span(start_hour, start_minute, end_hour, end_minute, item_type='event', &block)
    span_tag = "<span class=\"agenda-event from-#{start_hour}"
    span_tag << "-#{start_minute}" if start_minute.to_i > 0
    span_tag << " to-#{end_hour}"
    span_tag << "-#{end_minute}" if end_minute.to_i > 0
    span_tag << (item_type == 'event' ? ' blue-gradient' : ' anthracite-gradient')
    span_tag << "\">"

    yield span_tag

    span_tag << "</span>"
  end

  def time_tag(start_at, end_at, item_type='event')
    time_tag = "<time>"
    if item_type == 'event'
      time_tag << (start_at.min.to_i > 0 ? start_at.strftime('%l:%M %p') : start_at.strftime('%l %p'))
#     time_tag << (end_at.min.to_i > 0 ? end_at.strftime('%l:%M %p') : end_at.strftime('%l %p'))
    else
      time_tag << "4 PM - 5 PM"
    end
    time_tag << "</time>"
    time_tag
  end

  def format_currency(amount)
    number_to_currency(amount, precision: 0)
  end

  def goal(block_name, summary)
    format_currency(summary.send("#{block_name}_goal".to_sym))
  end

  def cash_to_date(block_name, summary)
    format_currency(summary.cash_to_date(block_name))
  end

  def percent_complete(block_name, summary)
    (summary.percent_complete(block_name) * 100).round
  end

  def projected(block_name, summary)
    format_currency(summary.projected_cash(block_name))
  end

  def monthly_summary(club, current_date)
    club.monthly_summaries.current(current_date).first
  end

  def business_days_completed(club, current_date)
    ms = monthly_summary(club, current_date)
    if ms.nil?
      0
    else
      ms.daily_summaries.count
    end
  end

  def business_days_in_month(club, current_date)
    ms = monthly_summary(club, current_date)
    if ms.nil?
      0
    else
      ms.business_days_in_month
    end
  end

  def over_under(block_name, summary)
    amount = summary.over_under(block_name)
    class_color = amount < 0 ? 'red' : 'green'
    "<td class=\"align-right #{class_color}\"><strong>#{format_currency(amount)}</strong></td>".html_safe
  end

  def over_under_summary(amount)
    class_color = amount < 0 ? 'red' : 'green'
    "<td class=\"#{class_color}\"><strong>#{format_currency(amount)}</strong></td>".html_safe
  end

  def format_delivery_date(date)
    if date.today?
      date.strftime('%I:%M%P')
    else
      date.strftime('%m/%d/%Y %I:%M%P')
    end
  end
end
