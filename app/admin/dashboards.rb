#coding: utf-8
ActiveAdmin::Dashboards.build do

  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  section "最近的变更的项目" do
    ul do
      Project.order(:updated_at).limit(30).collect do |project|
        li link_to(project.name,admin_project_path(project))
      end
    end
  end

  section "最近变更的部门" do
    ul do
      Dep.order(:updated_at).limit(30).collect do |dep|
        li link_to(dep.name,admin_dep_path(dep))
      end
    end
  end

  section "最近变更的员工" do
    ul do
      Person.order(:updated_at).limit(30).collect do |person|
        li link_to(person.name,admin_person_path(person))
      end
    end   
  end
  
  # == Render Partial Section
  # The block is rendererd within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.

end
