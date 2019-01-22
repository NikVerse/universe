public with sharing class TriggerHandlerManager {

    private static final String NAMESPACE = '';

    public static void handle(String objectName) {

        Trigger_Handler__mdt[] handlers = new Trigger_Handler__mdt[] {};

        switch on Trigger.operationType {

            when BEFORE_INSERT {
                handlers = getHandlers(objectName, NAMESPACE + 'Before_Insert__c');
            }
            when AFTER_INSERT {
                handlers = getHandlers(objectName, NAMESPACE + 'After_Insert__c');
            }
            when BEFORE_UPDATE {
                handlers = getHandlers(objectName, NAMESPACE + 'Before_Update__c');
            }
            when AFTER_UPDATE {
                handlers = getHandlers(objectName, NAMESPACE + 'After_Update__c');
            }
            when BEFORE_DELETE {
                handlers = getHandlers(objectName, NAMESPACE + 'Before_Delete__c');
            }
            when AFTER_DELETE {
                handlers = getHandlers(objectName, NAMESPACE + 'After_Delete__c');
            }
            when AFTER_UNDELETE {
                handlers = getHandlers(objectName, NAMESPACE + 'After_Undelete__c');
            }
        }

        if (!handlers.isEmpty()) {

            for (Trigger_Handler__mdt handler :handlers) {

                Type classType = Type.forName(handler.Class__c);
                TriggerHandlerInterface handlerInterface = (TriggerHandlerInterface) classType.newInstance();
                handlerInterface.execute(Trigger.old, Trigger.new);
            }
        }
    }

    private static Trigger_Handler__mdt[] getHandlers(String objectName, String filterField) {

        String query = 'SELECT Class__c FROM Trigger_Handler__mdt WHERE {FIELD} = true ';
        query += 'AND Active__c = true AND Object__c = :objectName ORDER BY Load_Order__c';

        return (Trigger_Handler__mdt[]) Database.query(query.replace('{FIELD}', filterField));
    }

}
