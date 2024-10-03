class Api::StudentsController < Api::BaseController

  def index
    @students = Indivadvice.students.select([:id, :indivname, :indivadvicetarget_id, :startyear, :startmonth, :endyear, :endmonth]).where(user_id: params[:academic_id]).where('startyear >= 2018')
    render json: @students
  end

  def show
    Indivadvice.find(params[:id])
  end

  def create
    @institution = Institution.where('lower(name) = ?', params["students"]["faculty"].downcase).first
    @parent_institution = Institution.where('lower(name) = ?', params["students"]["institution_name"].downcase).first
    university_id = 1

    if @institution.nil?
      parent_institutiontitle = []
      child_institutiontitle = []

      Institutiontitle.all.each do |x|
        if params["students"]["institution_name"].downcase.include? x.name.downcase
          parent_institutiontitle << x.id
        end
        if params["students"]["faculty"].downcase.include? x.name.downcase
          child_institutiontitle << x.id
        end
      end

      if @parent_institution.nil?
        @parent_institution = Institution.create(institutiontype_id: params["students"]["institutiontype_id"], name: params["students"]["institution_name"],
          institutiontitle_id: parent_institutiontitle[0], country_id: params["students"]["country_id"], registered_by_id: params["students"]["tutor_id"])
      end

      @institution = Institution.create(institutiontype_id: params["students"]["institutiontype_id"], name: params["students"]["faculty"],
        institution_id: @parent_institution.id, institutiontitle_id: child_institutiontitle[0], country_id: params["students"]["country_id"], registered_by_id: params["students"]["tutor_id"])
    end
    university_id = @parent_institution.id if @parent_institution

    @career = Career.where('lower(name) = ?', params["students"]["degree_name"].downcase).where(degree_id: params["students"]["degree_id"]).first
    if @career.nil?
      @career = Career.create(name: params["students"]["degree_name"], degree_id: params["students"]["degree_id"], institution_id: @institution.id, registered_by_id: params["students"]["tutor_id"])
    end


    @indivadvice = Indivadvice.new(institution_id: @institution.id, indivadvicetarget_id: params["students"]["activity_id"].to_i, indivname: params["students"]["name"],
      startyear: params["students"]["startyear"], startmonth: params["students"]["startmonth"], hours: params["students"]["hours"], endmonth: params["students"]["endmonth"],
      endyear: params["students"]["endyear"], registered_by_id: params["students"]["tutor_id"], user_id: params["students"]["tutor_id"], degree_id: params["students"]["degree_id"],
      career_id: @career.id, status_id: params["students"]["status_id"], country_id: params["students"]["country_id"], university_id: university_id)

    if @indivadvice.save
      render json: @indivadvice, status: 201, location: api_student_url(@indivadvice)
      #@indivadvice = Indivadvice.new(indivadvice_params)
    else
      render json: { errors: @indivadvice.errors }, status: 422
    end

    #json_response(@todo, :created)
  end
end
