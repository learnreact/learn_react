module Admin
  class LessonsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Lesson.
    #     page(params[:page]).
    #     per(10)
    # end

    def find_resource(param)
      Lesson.find_by!(slug: param)
    end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
