trigger TaskCreationTrigger on Task (after insert, after update) {

    TaskCreationTriggerHelper.taskCreation(Trigger.old, Trigger.new, Trigger.oldMap);

}

