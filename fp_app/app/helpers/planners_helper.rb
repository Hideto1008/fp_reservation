module PlannersHelper
  def sort_option(name_cont)
    [
      [ "Order of registration", planners_path(sort: "order_of_registration", name_cont: name_cont) ],
      [ "Total of Consultations", planners_path(sort: "total_of_consultations", name_cont: name_cont) ]
    ]
  end

  def set_planner_icon(planner)
    planner.icon_path.presence || asset_path('default_icon.png')
  end
end
