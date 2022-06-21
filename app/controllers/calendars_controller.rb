class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']
    #曜日を配列に入れる。日は0

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 今日の日付を取得できる。
    # また 今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)
    ##planモデルの今日から1週間後までの日付のレコードを取得

    7.times do |x|
      today_plans = []
      plans.each do |plan| #上記plansの配列をeachメソッドで一つずつ取り出す。
        today_plans.push(plan.plan) if plan.date == @todays_date + x ##取り出したレコードのdateカラム（日付）が最近1週間の日付（date）と一致すればplanのデータをtoday_plans配列に追加する。まずデータが存在するか（レコードが存在するか）today_plans配列に追加する。
      end

      wday_num = (@todays_date+x).wday ##今日の日付から1週間分の日付の曜日表示
      if wday_num >= 7
        wday_num = wday_num -7
      end

      days = { month: (@todays_date + x).month, date: (@todays_date+x).day, plans: today_plans,wday: wdays[(@todays_date+x).wday]} ##week_dayにハッシュ形式で1週間分のデータを入れる
      @week_days.push(days)
    end

  end
end
