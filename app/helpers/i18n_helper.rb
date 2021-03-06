# encoding: utf-8
module I18nHelper
  def translate_category(string)
     case string
       when /Investigador Tit\. C/
            "Professor" 
       when /Investigador Tit\. B/
         "Associate Professor" 
       when /Investigador Tit\. A/
         "Assistant Professor" 
       when /Investigador Asoc\./
         "Research Associate" 
       when /visitante/
         "Visitor"
       when /posdoc/
         "Posdoctoral scholar"
       when /Técnico académico/
          "Technician"
        when /emérito/
          "Professor Emeritus"
       else 
          "Not Defined"
     end
  end

  def localized_month_list
    Range.new(1,12).collect do |m|
      [I18n.t("date.month_names")[m], m]
    end
  end
end
