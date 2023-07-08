# db/seeds.rb

# User seeds
10.times do |i|
  User.create!(
    name: "user#{i + 1}",
    email: "user#{i + 1}@example.com",
    password: "password",
    role: i.zero? ? "admin" : "general" # Ensure there is at least one admin
  )
end

# Label seeds
10.times do |i|
  Label.create!(
    name: "Label #{i + 1}"
  )
end

# Task seeds
users = User.all
labels = Label.all

users.each do |user|
  10.times do |i|
    task = Task.create!(
      title: "Task #{i + 1} for #{user.name}",
      content: "Task content #{i + 1}",
      deadline: Time.now + rand(1..10).days,
      status: Task.statuses.values.sample, # randomly assign a status
      priority: Task.priorities.values.sample, # randomly assign a priority
      user: user
    )
    task.labels << labels.sample(rand(1..3)) # randomly assign 1 to 3 labels
  end
end
