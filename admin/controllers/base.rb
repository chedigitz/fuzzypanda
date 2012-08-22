Admin.controllers :base do

  get :index, :map => "/" do
  	if current_account.role == 'crew'
      @callsheets = Callsheet.where(:conditions => {:call_time.gte =>Time.now, :account_ids => current_account.id }).order(:call_time.asc)
  	  logger.info "THIS IS OPEN ASSIGMENTS = #{@callsheets.to_json}"
      @un_assigments= Assigment.all(:conditions => {:account_id => current_account.id, :settled => false})
      logger.info "this is UNPAID = #{@un_assigments.to_json}" 
      render "base/index"
     elsif current_account.role == 'partner'
        @callsheets = Callsheet.where(:conditions => {:call_time.gte => Time.now}).order(:call_time.desc).order(:call_time)
        @un_assigments = Assigment.all(:conditions => {:settled => false})
        render "base/admin"
     elsif current_account.role == 'admin'
        @callsheets = Callsheet.where(:conditions => {:call_time.gte => Time.now}).order(:call_time.desc).order(:call_time)
         logger.info "ACCOUNT ROLE = #{current_account.role}"
         logger.info "CALLSHEET IS #{@callsheets.to_json}"
         render "base/admin"
      end

  end
end
