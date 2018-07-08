class ApiController < ApplicationController

  def create
    begin
      execute_job params[:name]
    rescue => err
      redirect_back fallback_location: root_path, alert: err
      return
    end
    redirect_back fallback_location: root_path, notice: "Task '#{params[:name]}' is executed successfully"
  end

  private
    # Job を実行
    def execute_job(job_name)
      case job_name
      when "import_from_esa_to_db" then
        import_from_esa_to_db
      when "export_from_db_to_growi" then
        export_from_db_to_growi
      else
        raise 'Unknown job name'
      end
    end

    # esa.io から DB へインポート
    # ref. https://qiita.com/chatora_mikan/items/fda23646a37b91ac1716
    def import_from_esa_to_db
      execute_rake_task('esa:import_to_db')
    end

    # DB のデータを GROWI へエクスポート
    # ref. https://qiita.com/chatora_mikan/items/fda23646a37b91ac1716
    def export_from_db_to_growi
      execute_rake_task('esa:export_to_growi')
    end

    # Rake タスクを実行
    # ref. https://qiita.com/chatora_mikan/items/fda23646a37b91ac1716
    def execute_rake_task(task_name)
      require 'rake'
      Rails.application.load_tasks

      begin
        Rake::Task[task_name].execute
      rescue => err
        raise err
      ensure
        # clearをしないと次のリクエスト時にload_tasksでタスクが再度読み込まれ、execute内で２回実行されてしまう。
        # さらにリクエストがあると３、４とどんどん増えるていく罠
        Rake::Task[task_name].clear
      end
    end
end
