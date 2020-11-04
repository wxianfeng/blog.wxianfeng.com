class NotificationMailer < ActionMailer::Base
  helper :mail
  
  def article(article, user)
    setup(user, article)
    @subject        = "[#{article.blog.blog_name}] New article: #{article.title}"
    @body[:article] = article
  end

  def comment(comment, user)
    setup(user, comment)
    if user.class == User
      @subject        = "[#{comment.blog.blog_name}] New comment on #{comment.article.title}"
      @body[:article] = comment.article
      @body[:comment] = comment
    elsif user.class == Comment
      logger.debug "debug --- #{comment.inspect}"
      @subject        = "[#{Blog.first.blog_name}] New comment on #{comment.article.title}"
      @body[:article] = comment.article
      @body[:comment] = comment
    end
  end

  def trackback(sent_at = Time.now)
    setup(user, trackback)
    @subject          = "[#{trackback.blog.blog_name}] New trackback on #{trackback.article.title}"
    @body[:article]   = trackback.article
    @body[:trackback] = trackback
  end

  def notif_user(user)
    @body[:user] = user
    @body[:blog] = Blog.default
    @recipients  = user.email
    @from        = Blog.default.email_from
    @headers     = {'X-Mailer' => "Typo #{TYPO_VERSION}"}
  end

  private
  def setup(user, content)
    if user.class == User
      @body[:user] = user
      @body[:blog] = content.blog
      @recipients  = user.email
      @from        = content.blog.email_from
      @headers     = {'X-Mailer' => "Typo #{TYPO_VERSION}"}
    elsif user.class == Comment
      @body[:user] = User.first
      @body[:blog] = Blog.first
      @recipients  = user.email
      @from        = Blog.first.email_from
      @headers     = {'X-Mailer' => "Typo #{TYPO_VERSION}"}
    end
  end

end
