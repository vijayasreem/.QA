// Generated Aura Component
<aura:component>
    <aura:attribute name="test" type="String" default="test"/>
    <aura:handler name="init" value="{!this}" action="{!c.doInit}"/>

    <!-- Component Body -->
    <div class="userStory">
        {!v.test} User Story
    </div>
</aura:component>

// Generated Controller
({
    doInit : function(component, event, helper) {
        // Do Initialization in here
    }
})