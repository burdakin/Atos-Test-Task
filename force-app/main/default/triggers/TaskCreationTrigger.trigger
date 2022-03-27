trigger TaskCreationTrigger on Task (after insert, after update, after delete) {
    Boolean isDel = Trigger.isDelete; 
    TaskCreationTriggerHelper.taskCreation(isDel, Trigger.old, Trigger.new, Trigger.oldMap);

}

