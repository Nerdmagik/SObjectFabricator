public virtual class sfab_FabricatedSObject {
    private Type sType;
    @testVisible private List<sfab_FabricatedSObjectNode> nodes = new List<sfab_FabricatedSObjectNode>();

    public sfab_FabricatedSObject(Type sType) {
        this.sType = sType;
    }

    public sfab_FabricatedSObject(Type sType, Map<Schema.SObjectField, Object> fields) {
        this(sType);

        for (Schema.SObjectField field : fields.keySet()) {
            setField(field, fields.get(field));
        }
    }

    @testVisible protected sfab_FabricatedSObject(Type sType, List<sfab_FabricatedSObjectNode> nodes) {
        this.sType = sType;
        this.nodes = nodes;
    }
    
    
    public sfab_FabricatedSObject setFakeId() {
        return setField( getSObjectField( 'Id' ), sfab_FabricatedSObjectId.getFakeId( getSObjectType() ) );
    }
    
    
    public sfab_FabricatedSObject setFakeId( Schema.SObjectField field, Type type ) {
        Schema.SObjectType sObjectType = getSObjectType( type );
        return setFakeId( field, sObjectType );
    }
    
    
    public sfab_FabricatedSObject setFakeId( Schema.SObjectField field, Schema.SObjectType sObjectType ) {
        return setField( field, sfab_FabricatedSObjectId.getFakeId( sObjectType ) );
    }
    
    
    public sfab_FabricatedSObject setTimestamps() {
        Datetime dt = Datetime.now();
        Id userId = sfab_FabricatedSObjectId.getFakeId( User.SObjectType );
        return setTimestamps( dt, userId );
    }
    
    
    public sfab_FabricatedSObject setTimestamps( Datetime dt ) {
        return setTimestamps( dt, sfab_FabricatedSObjectId.getFakeId( User.SObjectType ) );
    }
    
    
    public sfab_FabricatedSObject setTimestamps( Datetime dt, Id userId ) {
        return setField( getSObjectField( 'CreatedDate' ), dt )
          .setField( getSObjectField( 'CreatedById' ), userId )
          .setField( getSObjectField( 'LastModifiedDate' ), dt )
          .setField( getSObjectField( 'LastModifiedById' ), userId );
    }
    
    public sfab_FabricatedSObject setField(Schema.SObjectField field, Object value) {
        nodes.add(new sfab_FieldValuePairNode(field, value));
        return this;
    }

    public sfab_FabricatedSObject setParent(String relationshipName, sfab_FabricatedSObject fabricatedParent) {
        nodes.add(new sfab_ParentRelationshipNode(relationshipName, fabricatedParent));
        return this;
    }

    public sfab_FabricatedSObject setChildren(String relationshipName, List<sfab_FabricatedSObject> fabricatedChildren) {
        nodes.add(new sfab_ChildRelationshipNode(relationshipName, fabricatedChildren));
        return this;
    }

    public SObject toSObject() {
        return (SObject)JSON.deserialize(JSON.serialize(serialize()), sType);
    }

    public virtual Map<String, Object> serialize() {
        Map<String, Object> fields = new Map<String, Object>();

        for (sfab_FabricatedSObjectNode node : nodes) {
            fields.putAll(node.serialize());
        }

        return fields;
    }
    
    
    public Schema.SObjectType getSObjectType() {
        SObject obj = (SObject) sType.newInstance();
        return obj.getSObjectType();
    }
    
    
    public Schema.SObjectType getSObjectType( Type type ) {
        SObject obj = (SObject) type.newInstance();
        return obj.getSObjectType();
    }
    
    
    public Schema.SObjectField getSObjectField( String fieldAPIName )
    {
        Map<String, Schema.SObjectField> fieldMap = getSObjectType().getDescribe().fields.getMap();
        if(!fieldMap.containsKey( fieldAPIName )) {
            throw new sfab_InvalidFieldException( 'The ' + fieldAPIName + ' field does not exist on object type: ' + sType.getName() );
        }
        return fieldMap.get( fieldAPIName );
    }
    
    class sfab_InvalidFieldException extends Exception {}
}