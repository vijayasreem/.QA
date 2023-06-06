// Unit Tests
describe('My Aura Component', function() {
    it('should have default value for "test" attribute', function() {
        var component = new MyAuraComponent();
        expect(component.get('v.test')).toEqual('test');
    });
    it('should call the doInit function on initializing the component', function() {
        var component = new MyAuraComponent();
        var spy = spyOn(component, 'doInit');
        component.init();
        expect(spy).toHaveBeenCalled();
    });
});