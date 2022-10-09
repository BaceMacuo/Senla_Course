/**
 * Created by booka on 10.10.2022.
 */

global class NotifyContactRentEnding_Schdule  implements Schedulable {
    global void execute(SchedulableContext ctx) {
        NotifyContactRentEnding b = new NotifyContactRentEnding();
        database.executeBatch(b);
    }
}

//Code to run schedule
// NotifyContactRentEnding_Schdule s = new NotifyContactRentEnding_Schdule();
// String expression='0 0 6 * * ? *';
// System.Schedule('Notify contacts end rental', expression, s);