/*!
 * \file
 * \author Carlo Bernaschina (www.bernaschina.com)
 * \copyright Copyright 2013 Carlo Bernaschina. All rights reserved.
 * \license This project is released under the GNU Lesser General Public License.
 */

#include "MVariableElement.h"

using namespace mpk;

MVariableElement::MVariableElement(const wchar_t* name,double value){
	this->SetName(name);
	this->SetValue(value);
}
MVariableElement::MVariableElement(MVariableElement &origin){
	(*this)=origin;
}
void MVariableElement::SetName(const wchar_t* name){
	if (!name) return;
	//wcscpy_s(m_name,variables_MAX_NAME_LEN+1,name);
	wcsncpy(m_name,name, variables_MAX_NAME_LEN+1);
	*(m_name + variables_MAX_NAME_LEN + 1) = '\0';
}
