class Membership < ActiveRecord::Base
  attr_accessible :project, :role, :user
  after_create :email_pending_confirmations

  validates :project, :role, :user, :state, :user_id, :project_id, {
    presence: true
  }

  validates :state, {
  inclusion: { :in => %w(new pending active closed) }
  }

  validates :role, {
    inclusion: { :in => %w(owner collaborator client) }
  }

  belongs_to :user, {
    inverse_of: :memberships
  }

  belongs_to :project, {
    inverse_of: :memberships
  }

  state_machine :state, :initial => :pending do
    def ignore_method_conflicts
      true
    end
    after_transition :pending => :active, :do => :email_accepted_confirmations
    after_transition :pending => :closed, :do => :email_decline_confirmations
    after_transition :active => :closed, :do => :email_closed_confirmations
    after_transition :closed => :active, :do => :email_reopen_confirmations

    event :approve_membership do
      transition :pending => :active
    end

    event :decline_membership do
      transition :pending => :closed
    end

    event :remove_membership do
      transition :active => :closed
    end

    event :reopen_membership do
      transition :closed => :active
    end

    state :pending
    state :active
    state :closed

  end

  def email_accepted_confirmations
    puts "Email accepted confirmations"
    puts "Here are the confirmations you ordered"
  end

  def email_pending_confirmations
    puts "Email pending confirmation"
    puts "Here are the confirmations you ordered"
  end

  def email_decline_confirmations
    print "Email decline confirmations"
  end

  def email_closed_confirmations
    print "Email closed confirmations"
  end

  def email_reopen_confirmations
    print "Email reopen confirmations"
  end

end
