<input id="tv{$tv->id}" name="tv{$tv->id}" type="hidden" class="textfield" value="{$tv->get('value')|escape}"{$style} tvtype="{$tv->type}" />
<div id="tvpanel{$tv->id}">
</div>
<div id="tvpanel2{$tv->id}">
</div>
<br/>

<script type="text/javascript">
    // <![CDATA[
    {literal}
    
    MODx.panel.multiTvItem = function(config) {
        config = config || {};
		Ext.applyIf(config,{
            layout: 'form'
            ,autoHeight: true
            ,border: false
            ,style:{
                'margin-bottom': '5px'
                ,'border-bottom-width':'1px'	
            } 
            ,hideLabels: false
            ,defaults: {
                autoHeight: true
                ,border: false
            }
            ,items: [{                
			    xtype: 'button'
                ,text: 'delete item'
                ,style:{
                    'float': 'right'
                }
                ,listeners: {
                    'click': {fn:function() {
						var _thisitem = this;
						var itemIdentifier = this.itemIdentifier;
                        Ext.Msg.confirm(_('warning') || '','Remove Item?' || '',function(e) {
                            if (e == 'yes') {
                                console.log(config);
								Ext.get(config.id).remove();	
                                config.tvpanel.collectItems();		
                            }
	                    }),this;
                    },scope:this}
                }}
				,{
				xtype: 'fieldset'
				,collapsible: false
                //,collapsed: config.toggleCb=='on'?false:true
				,collapsed: false
				,checkboxToggle: true
				,checkboxName: 'tv'+this.tvid+'_toggleCb_'+config.itemid
                ,autoHeight: true
                ,title: 'show Fields'
				,items: config.itemfields
				,width: '500px'
			}] 
        });
        MODx.panel.multiTvItem.superclass.constructor.call(this,config);
        this.addEvents({select: true});
    };
    Ext.extend(MODx.panel.multiTvItem,MODx.Panel);
    Ext.reg('modx-panel-multitvitem',MODx.panel.multiTvItem);

    MODx.panel.multiItemsTV = function(config) {
        config = config || {};
        Ext.applyIf(config,{
            autoHeight: true
            ,border: false
            ,style:{
                'margin-bottom': '5px'
                ,'border-bottom-width':'1px'	
            } 
            ,hideLabels: true
            ,defaults: {
                autoHeight: true
                ,border: false
            }
            ,items: [{
                xtype: 'button'
                ,html: '<span>Add another item</span>'
				,cls: 'ux-row-action-item ux-row-action-text'
                ,listeners: {
                    'click': {fn:function() {
                        this.addItem({data:{}});                        
                    },scope: this}
                }
            }] 
        });
		
        MODx.panel.multiItemsTV.superclass.constructor.call(this,config);
		this.loadInitItems();
        this.addEvents({select: true});
    }
    Ext.extend(MODx.panel.multiItemsTV,MODx.Panel,{
	itemIdentifier: 0
	,tvid:'{/literal}{$tv->id}{literal}'
    ,fields: Ext.util.JSON.decode('{/literal}{$fieldnames}{literal}')
	,captions: Ext.util.JSON.decode('{/literal}{$captions}{literal}')		
	,loadInitItems: function(){
    var items_string = Ext.select("#tv"+this.tvid).elements[0].value;
    var	items = [];
    try {
        items = Ext.util.JSON.decode(items_string);
    }
    catch (e){
      
    }
	
    if (items.length>0){
        for (var i = 0; i < items.length; i++) {
            //menueItem_Identifier++;
            this.addItem({data:items[i]});
        }
    }
	else {
		//menueItem_Identifier++;
        this.addItem({data:{}});
	}
	}
	,addItem: function(config){

		var data=config.data || null;
		
		this.itemIdentifier++;
		var itemfields=[];
        for (i=0;i<this.fields.length;i++) {
 			itemfield = {
                xtype: 'textfield'
                ,name: 'tv'+this.tvid+'_'+this.fields[i]+'_'+this.itemIdentifier
                ,id: 'tv'+this.tvid+'_'+this.fields[i]+'_'+this.itemIdentifier
                ,value: data[this.fields[i]]||''
                ,width: '293px'
				,fieldLabel: this.captions[i]
                ,cls:'tv'+this.tvid+this.fields[i]
                ,listeners: {
                    'change': {fn:function(data) {
                        this.fireEvent('change',data);
                        this.collectItems();
                    },scope:this}
                }
             }
			 itemfields.push(itemfield);
		};
		//console.log(items);	

		
		MODx.load({
			xtype: 'modx-panel-multitvitem',
			renderTo: 'tvpanel2' + this.tvid,
			//fields:this.fields,
			tv: this.tvid,
			itemid: this.itemIdentifier,
			//toggleCb:data['toggleCb']||'off',
			cls: 'tv' + this.tvid + '_item',
			id: 'tv' + this.tvid + '_item' + this.itemIdentifier,
			width: '97%',
			data: {description:''}
			,itemfields : itemfields
			,tvpanel:this
		});

	}
    ,collectItems: function(){
        var items=[];
        var rows = Ext.select('.tv'+this.tvid+'_item');
        //console.log(this);
		var inputs = null;
		var item = null;
		var _this = this;
		rows.each(function(row){
            inputs = row.select('input');
			//console.log(inputs);
			item={};
			inputs.each(function(input){
            	var name = input.dom.name.substring(input.dom.name.indexOf("_")+1, input.dom.name.lastIndexOf("_"));
				item[name]=input.getValue();
				//console.log(name);
			});
			items.push(item);	
            //console.log(item);
        });
		//console.log(items);
        Ext.select('#tv'+this.tvid).elements[0].value = Ext.util.JSON.encode(items);
    }	
		
	});
    Ext.reg('modx-panel-multiitemstv',MODx.panel.multiItemsTV);

        MODx.load({
            xtype: 'modx-panel-multiitemstv'
            ,renderTo: 'tvpanel{/literal}{$tv->id}{literal}'
            ,tv: '{/literal}{$tv->id}{literal}'
            ,cls:'tv{/literal}{$tv->id}{literal}_items'
            ,id:'tv{/literal}{$tv->id}{literal}_items'
            ,width: '97%'			
        });


</script>
