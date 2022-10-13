/**
 * Created by booka on 10.10.2022.
 */

global class NotifyContactRentEnding_Schedule implements Schedulable {
    global void execute(SchedulableContext ctx) {
        NotifyContactRentEnding_Batch b = new NotifyContactRentEnding_Batch();
        database.executeBatch(b);
    }
}

//Code to run schedule
// NotifyContactRentEnding_Schedule s = new NotifyContactRentEnding_Schedule();
// String expression='0 0 6 * * ? *';
// System.Schedule('Notify contacts end rental', expression, s);