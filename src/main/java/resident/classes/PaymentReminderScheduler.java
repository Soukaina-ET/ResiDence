package resident.classes;


import org.quartz.*;
import org.quartz.impl.StdSchedulerFactory;

public class PaymentReminderScheduler {

    public static void main(String[] args) {
        try {
            // Créer une instance du Scheduler
            Scheduler scheduler = StdSchedulerFactory.getDefaultScheduler();

            // Démarrer le Scheduler
            scheduler.start();

            // Définir le Job
            JobDetail job = JobBuilder.newJob(PaymentReminderJob.class)
                    .withIdentity("paymentReminderJob", "group1")
                    .build();

            // Définir le Trigger pour exécuter le Job tous les jours à minuit
            Trigger trigger = TriggerBuilder.newTrigger()
                    .withIdentity("paymentReminderTrigger", "group1")
                    .withSchedule(CronScheduleBuilder.dailyAtHourAndMinute(0, 0)) // Tous les jours à minuit
                    .build();

            // Associer le Job au Trigger et planifier
            scheduler.scheduleJob(job, trigger);

            System.out.println("Le Scheduler est démarré et le Job est planifié.");

        } catch (SchedulerException e) {
            e.printStackTrace();
        }
    }
}
