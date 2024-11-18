module PlannersHelper
  def sort_option(params)
    [
      ['Order of registration', planners_path(sort: 'order_of_registration', name_cont: params[:name_cont])],
      ['Total of Consultations', planners_path(sort: 'total_of_consultations', name_cont: params[:name_cont])]
    ]
  end
end
