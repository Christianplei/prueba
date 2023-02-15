<%@ page language="java" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles"%>
<%@ taglib uri="/WEB-INF/extremecomponents.tld" prefix="ec"%>

<%@ page import="java.util.ResourceBundle,org.apache.struts.Globals,java.util.Locale;"%>
<%ResourceBundle mensajes = ResourceBundle.getBundle("com.aeroman.seguridadae.resource.ApplicationResources",(Locale) request.getSession().getAttribute(Globals.LOCALE_KEY));%>

<tiles:insert name="plantillaBase" definition="plantillaBase">

	<tiles:put name="base">
		<html:base />
	</tiles:put>
	
	<tiles:put name="scripts">
        <script language="javascript" src="<%=request.getContextPath()%>/js/popcalendar.js"></script>
		<script type="text/javascript" language="javascript">
		
			function tableClick(optionGroupCode, optionGroupName){
				document.getElementById('optionGroupCode').value = optionGroupCode;
				document.getElementById('optionGroupName').value = optionGroupName;
				habilitar();
			}
			
			function habilitar(){
				$('#accionInsert').SlideOutDown('fast',$('#accionUpdate').SlideInDown('slow'));
			}
			
			var flag = "in";
	      	function pulsateMessaje(){	                        
	        	if(flag == "in"){          
	          		flag = "out";
	          		$('#mensaje').DropInRight(1000);
	          		setTimeout('pulsateMessaje()',5000);
	        	}
	        	else 
	        		if(flag == "out"){          
	          			flag = "in";
	          			$('#mensaje').DropOutRight(1000);	          			
	        	}
	      	}
        
      function genAlmacenList()
      {
            var codPue = document.getElementById("pue_codigo");
            var sistema = document.getElementById("systemid");
            
            if(codPue.value == '' || sistema.value == ''){
                 alert("Debe de especificar el puesto y el sistema antes de proseguir");   
            }
            else{
                    url="admRoleXPuestoAction.do?cmd=FindListOpciones&pue_codigo="+codPue.value+"&systemid="+sistema.value;
                           
                    //Ajax
                    if (window.XMLHttpRequest){ // Non-IE browsers
                       req = new XMLHttpRequest();
                       req.onreadystatechange = populateAlmacenList;
                            try {
                              req.open("POST", url, true); //was get
                            } catch (e) {
                              alert("Cannot connect to server");
                            }
                       req.send(null);
                    } else if (window.ActiveXObject) { // IE      
                          req = new ActiveXObject("Microsoft.XMLHTTP");
                          if (req) {
                            req.onreadystatechange = populateAlmacenList;
                            req.open("POST", url, true);
                            req.send();
                          }
                    }
            }
      }
      
      function populateAlmacenList(){
            document.getElementById('listaDisponible').options.length = 0;
            document.getElementById('listaActuales').options.length = 0;            
            if (req.readyState == 4) 
            { // Complete
                 textToSplit = req.responseText
                 returnedLsts=textToSplit.split("_|_");
                 var strLista1 = returnedLsts[0];
                 var strLista2 = returnedLsts[1];
                 var lista1 = strLista1.split("||");
                 var lista2 = strLista2.split("||");
                 for ( var i=0; i<lista1.length-1; i++ )
                 {
                     valueLabelPair = lista1[i].split("|")
                     document.getElementById('listaDisponible').options[i] = new Option(valueLabelPair[0], valueLabelPair[1]);
                 }   
                 
                 for ( var i=0; i<lista2.length-1; i++ )
                 {
                     valueLabelPair = lista2[i].split("|")
                     document.getElementById('listaActuales').options[i] = new Option(valueLabelPair[0], valueLabelPair[1]);
                 }  
            }
        }
         
        //para ver la longitu del select y extraer su data 
       function enviarFormulario(form, i){
              //alert(document.getElementById('listaDisponible').length);
               var listadisp = document.getElementById("listaDisponible");
               var listaactu = document.getElementById("listaActuales"); 
               var disponibles="";
               var actuales="";
               var ruta;
               //se almacena en una cadena todos las opciones que estaran disponibles
               for(var i=0; i < listadisp.length; i++){
                    disponibles += ','+listadisp.options[i].value;
               }
               //se almacena todas las opciones actuales
               for(var i=0; i < listaactu.length; i++){
                    actuales += ','+listaactu.options[i].value;
               }
               //alert(disponibles);
               //alert(actuales);
               ruta = "admRoleXPuestoAction.do?cmd=ingresaropciones&listaDisponible="+disponibles+"&listaActuales="+actuales+"&cantidad="+listadisp.length;
               form.action = ruta;
               form.submit();
        }
        
        
        
        //scripts para pasar los valores a las opciones
        function DoAdd(opcion)
            {
              if(opcion == '0'){
                  //se extrae de lo disponible para reasignarlo a lo que posee
                  //el valor  osea el id
                  var strId = document.getElementById("listaDisponible").options[document.getElementById("listaDisponible").selectedIndex].value;
                  //obtenemos el texto
                  var strText = document.getElementById("listaDisponible").options[document.getElementById("listaDisponible").selectedIndex].text;
                  AddItem(document.getElementById("listaActuales"), strText, strId);
                  RemoveItem(document.getElementById("listaDisponible"), document.getElementById("listaDisponible").selectedIndex);
              }
              else{
                  var strId = document.getElementById("listaActuales").options[document.getElementById("listaActuales").selectedIndex].value;
                  //obtenemos el texto
                  var strText = document.getElementById("listaActuales").options[document.getElementById("listaActuales").selectedIndex].text;
                  AddItem(document.getElementById("listaDisponible"), strText, strId);
                  RemoveItem(document.getElementById("listaActuales"), document.getElementById("listaActuales").selectedIndex);
              }
            }
            
        function DoAddTotal(opcion){
             if(opcion == '0'){             
                 var objetolista = document.getElementById("listaDisponible");
                 for(var i = 0; i < objetolista.length; i++){
                     AddItem(document.getElementById("listaActuales"), objetolista.options[i].text , objetolista.options[i].value);
                 }
                 while(objetolista.options.length){
                     objetolista.remove(0);
                 }
             }
             else{
                 var objetolista = document.getElementById("listaActuales");
                 for(var i = 0; i < objetolista.length; i++){
                     AddItem(document.getElementById("listaDisponible"), objetolista.options[i].text , objetolista.options[i].value);
                 }
                 while(objetolista.options.length){
                     objetolista.remove(0);
                 }
             }
        }

            var willy;
            function AddItem(objListBox, strText, strId)
            {
              var newOpt;
              newOpt = document.createElement("OPTION");
              //newOpt = new Option(strText,strId);
              //newOpt.id = strId;
              newOpt.value= strId;
              newOpt.text= strText;
              try{
                objListBox.add(newOpt,null);
              }catch(e){
                objListBox.add(newOpt); //Bug IE                
              }
            }
        
            function RemoveItem(objListBox, indexRemove)
            {
                objListBox.remove(indexRemove);
            }
        
            function GetItemIndex(objListBox, strId)
            {
              for (var i = 0; i < objListBox.children.length; i++)
              {
                var strCurrentValueId = objListBox.children[i].id;
                if (strId == strCurrentValueId)
                {
                  return i;
                }
              }
              return -1;
            }
            
            function abrirVentanaFecha(){
                 var fechaInicio, fechaFin, codigoRol;
                 var dato = document.getElementById("listaActuales").options[document.getElementById("listaActuales").selectedIndex];
                 alert(dato.value);
                 codigoRol = dato.value.substring(0, (dato.value.indexOf(";")));
                 fechaFin =  dato.value.substring( (dato.value.indexOf(";")) + 1, (dato.value.indexOf("-")) );
                 fechaInicio = dato.value.substring( (dato.value.indexOf("-")) + 1, dato.value.length);
                 
                 window.open('<%=request.getContextPath()%>/jsp/Administracion/obtenerFechaExpiracion.jsp?codigoRol='+codigoRol+'&fechaExpiracion='+fechaFin+'&fechaAsignacion='+fechaInicio,'_blank','scrollbars=yes,directories=no,resizable=yes,channelmode=no,titlebar=no,location=no, width=250,height=250','false');
            }
        
	</script>
	</tiles:put>

	<tiles:put name="title" type="String">
		<bean:message key="rol_pue.titulo" />
	</tiles:put>

	<tiles:put name="encabezado" type="String">
		<bean:message key="rol_pue.encabezado" />
	</tiles:put>

	<tiles:put name="contenido" type="String">

	<html:form action="/admRoleXPuestoAction.do" method="POST">
	<center>
	<table class="tableDefault">
            <tr>
                <td>
                    <center>
                        <table class="centerTableContentFormTop">
                             <tr>
                                <th>
                                     <bean:message key="rol_pue.Puesto"/>
                                </th>
                                <td colspan="4">                    
                                        <html:hidden property="pue_codigo" styleId="pue_codigo" />
                                        <html:text property="pue_nombre" styleId="pue_nombre" size="30" maxlength="200" styleClass="caja_texto_obligatorio" readonly="true" ></html:text>
                                        <input type="button" id="btnPue" onclick="abrirVentana('ldvAction.do?xmlArchivo=Puestos');" value="..."/>
                                        <html:messages id="message" footer="errores.pie" header="errores.cabecera" property="accesoUsuario.nombreUsuario.requerido">
                                            <br><span class="error" > <bean:write name="message" filter="false" /> </span>
                                        </html:messages>
                                </td>
                            </tr>       
                            <tr>
                                <th>
                                     <bean:message key="rol_pue.Sistema"/>
                                </th>
                                <td colspan="4">                    
                                        <html:hidden property="systemid" styleId="systemid" />
                                        <html:text property="systemname" styleId="systemname" size="30" maxlength="200" styleClass="caja_texto_obligatorio" readonly="true" ></html:text>
                                        <input type="button" id="btnsistemas" onclick="abrirVentana('ldvAction.do?xmlArchivo=sistemas');" value="..."/>
                                        <html:messages id="message" footer="errores.pie" header="errores.cabecera" property="accesoUsuario.systemname.requerido">
                                            <br><span class="error" > <bean:write name="message" filter="false" /> </span>
                                        </html:messages>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="5">
                                            <center> 
                                            <html:button property="definirdim" onclick="javascript:genAlmacenList()">
                                                    <bean:message key="opc.asignarvalores"/>
                                            </html:button> 
                                            </center>
                                </td>
                            </tr>                       
                        </table>
                    </center>
                </td>
            </tr>
        </table>
        <table class="tableDefault">
        <tr>
            <td>
                <center>
                    <table class="centerTableContentForm">
                        <tr id="opcionesid"> 
                             <th>
                                   <bean:message key="rol_pue.rol.disponible"/>       
                            </th>
                            <td>
                                <html:select property="listaDisponible" styleId="listaDisponible" size="10" >
                                </html:select>
                            </td>
                            <td class="botonesForm">
                                    <input type="button" name="pasarvalor" value=" >  " onclick="DoAdd(0)" /><br>
                                    <input type="button" name="regresarvalor" value=" <  " onclick="DoAdd(1)"  /><br>
                                    <input type="button" name="pasarvalortotal" value="> >" onclick="DoAddTotal(0)" /><br>
                                    <input type="button" name="regresarvalortotal" value="< <" onclick="DoAddTotal(1)" /><br>
                            </td>
                            <th>
                                   <bean:message key="rol_pue.rol.actuales"/>       
                            </th>
                            <td>
                                <html:select property="listaActuales" styleId="listaActuales" size="10" ondblclick="abrirVentanaFecha();" >
                                </html:select>
                            </td>
                        </tr>
                    </table>
                </center>
            </td>
        </tr>
	</table>
			<html:messages id="message" footer="errores.pie" header="errores.cabecera" property="optionRol.mensaje.exito">		          
		          <div id="mensaje" >
		          	 <bean:write name="message" filter="false" /> 
		    	  </div>
		    	  <script type="text/javascript" language="javascript">
		    	  	pulsateMessaje();
		    	  </script>
		        </html:messages>
                        
                        <html:messages id="message" footer="errores.pie" header="errores.cabecera" property="optionRol.mensaje.error">		          
                              <div id="mensajeError" >
                                     <bean:write name="message" filter="false" /> 
                              </div>
		        </html:messages>	
				
				<hr width="85%"  >
				
			</center>
			<logic:equal parameter="cmd" value='<%=mensajes.getString("opc.update")%>'>
				<script type="text/javascript" language="javascript" >
					habilitar();
				</script>
			</logic:equal>	
		        <input type="button"  id="cambioid" name="ver script" value="Actualizar" onclick="enviarFormulario(this.form, 1);" />
                        <html:button property="accion" styleId="cancel" onclick="window.location.reload()" >
				<bean:message key="opc.cancel"/>
			</html:button>
		</html:form>
		
		<BR>
		
	</tiles:put>

</tiles:insert>