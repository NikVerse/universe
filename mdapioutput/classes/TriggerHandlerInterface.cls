public interface TriggerHandlerInterface {

    void execute(sObject[] oldRecords, sObject[] newRecords);
}