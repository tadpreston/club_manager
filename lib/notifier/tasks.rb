module Notifier
  class Tasks

    class << self

      def config
        @@config ||= load_msg_params["tasks"]
      end

      def assigned_task_message(task)
        @task = task
        @send_to = task.owner
        @author = task.assignee
        @subject = "A task has been assigned to you"

        body = ERB.new(load_template('assigned_task_message')).result(binding)

        deliver_message(@author, @send_to, @subject, body)

      end

      def claim_task_message(task)
        @task = task
        @send_to = task.owner
        @author = task.assignee
        @subject = "Task has been claimed"

        body = ERB.new(load_template('claim_task_message')).result(binding)

        deliver_message(@author, @send_to, @subject, body)

      end

      def completed_task_message(task)
        @task = task
        @send_to = task.owner
        @author = task.assignee
        @subject = "Task has been completed"

        body = ERB.new(load_template('completed_task_message')).result(binding)

        deliver_message(@author, @send_to, @subject, body)

      end

       def method_missing(method, *args)
         split_method = method.to_s.split('_',2)
         if split_method[0] == 'deliver'
           self.send(split_method[1].to_sym, args[0])
         else
           super(method, *args)
         end
       end

      private

        def load_template(template_name)
          IO.read("#{Rails.root}/app/views/notifiers/tasks/#{template_name}.erb")
        end

        def deliver_message(from, send_to, subject, body)
          message = Message.create(author_id: from.id, send_to: send_to.full_name, subject: subject, body: body)
          message.deliver
        end

    end

  end

end
