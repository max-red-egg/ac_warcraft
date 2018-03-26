json.array! @notifications.limit(10) do |notification|
  json.id notification.id
  json.unchecked !notification.checked_at?
  json.template render partial: "notifications/#{notification.notifiable_type.underscore.pluralize}/#{notification.action}", locals: {notification: notification}, formats: [:html]

end