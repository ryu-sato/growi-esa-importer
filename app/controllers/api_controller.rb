class ApiController < ApplicationController

  def create
    execute_job params[:name]
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
      require 'rake'
      Rails.application.load_tasks
      Rake::Task['esa:import_to_db'].execute

      # clearをしないと次のリクエスト時にload_tasksでタスクが再度読み込まれ、execute内で２回実行されてしまう。
      # さらにリクエストがあると３、４とどんどん増えるていく罠
      Rake::Task['esa:import_to_db'].clear
    end

    # DB のデータを GROWI へエクスポート
    # ref. https://qiita.com/chatora_mikan/items/fda23646a37b91ac1716
    def export_from_db_to_growi
      require 'rake'
      Rails.application.load_tasks
      Rake::Task['esa:import_to_db'].execute

      # clearをしないと次のリクエスト時にload_tasksでタスクが再度読み込まれ、execute内で２回実行されてしまう。
      # さらにリクエストがあると３、４とどんどん増えるていく罠
      Rake::Task['esa:import_to_db'].clear
    end
end
