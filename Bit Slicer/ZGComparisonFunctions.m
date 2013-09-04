/*
 * Created by Mayur Pawashe on 8/18/10.
 *
 * Copyright (c) 2012 zgcoder
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * Neither the name of the project's author nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "ZGComparisonFunctions.h"
#import "ZGSearchData.h"

#define COMPARISON_PARAMETERS ZGSearchData * __unsafe_unretained searchData, const void *variableValue, const void *compareValue, ZGMemorySize size

#define NOT_EQUALS_CALLER_ARGUMENTS searchData, variableValue, compareValue, size

#define EQUALS_PLUS_CALLER_ARGUMENTS searchData, variableValue, &newCompareValue, size

#pragma mark Equal Functions

BOOL ZGInt8Equals(COMPARISON_PARAMETERS)
{
	return *((int8_t *)variableValue) == *((int8_t *)compareValue);
}

BOOL ZGInt16Equals(COMPARISON_PARAMETERS)
{
	return *((int16_t *)variableValue) == *((int16_t *)compareValue);
}

BOOL ZGInt32Equals(COMPARISON_PARAMETERS)
{
	return *((int32_t *)variableValue) == *((int32_t *)compareValue);
}

BOOL ZGInt64Equals(COMPARISON_PARAMETERS)
{
	return *((int64_t *)variableValue) == *((int64_t *)compareValue);
}

BOOL ZGFloatEquals(COMPARISON_PARAMETERS)
{
	return ABS(*((float *)variableValue) - *((float *)compareValue)) <= searchData->_epsilon;
}

BOOL ZGDoubleEquals(COMPARISON_PARAMETERS)
{
	return ABS(*((double *)variableValue) - *((double *)compareValue)) <= searchData->_epsilon;
}

BOOL ZGString8Equals(COMPARISON_PARAMETERS)
{
	return (searchData->_shouldIgnoreStringCase) ? (strncasecmp(variableValue, compareValue, (size_t)size) == 0) : (memcmp(variableValue, compareValue, (size_t)size) == 0);
}

BOOL ZGString16Equals(COMPARISON_PARAMETERS)
{
	BOOL isEqual = NO;
	
	if (searchData->_shouldIncludeNullTerminator)
	{
		size -= sizeof(unichar);
		// Check for the existing null terminator
		if (*((unichar *)(variableValue + size)) != 0)
		{
			return NO;
		}
	}
	
	if (searchData->_shouldIgnoreStringCase)
	{
		UCCompareText(searchData->_collator, variableValue, ((size_t)size) / sizeof(unichar), compareValue, ((size_t)size) / sizeof(unichar), (Boolean *)&isEqual, NULL);
	}
	else
	{
		isEqual = (memcmp(variableValue, compareValue, (size_t)size) == 0);
	}
	
	return isEqual;
}

BOOL ZGByteArrayEquals(COMPARISON_PARAMETERS)
{
	BOOL isEqual = NO;
	
	if (!searchData->_byteArrayFlags)
	{
		isEqual = (memcmp(variableValue, compareValue, (size_t)size) == 0);
	}
	else
	{
		const unsigned char *variableValueArray = variableValue;
		const unsigned char *compareValueArray = compareValue;
		
		isEqual = YES;
		
		unsigned int byteIndex;
		for (byteIndex = 0; byteIndex < size; byteIndex++)
		{
			if (!(searchData->_byteArrayFlags[byteIndex] & 0xF0) && ((variableValueArray[byteIndex] & 0xF0) != (compareValueArray[byteIndex] & 0xF0)))
			{
				isEqual = NO;
				break;
			}
			
			if (!(searchData->_byteArrayFlags[byteIndex] & 0x0F) && ((variableValueArray[byteIndex] & 0x0F) != (compareValueArray[byteIndex] & 0x0F)))
			{
				isEqual = NO;
				break;
			}
		}
	}
	
	return isEqual;
}

#pragma mark Less Than Functions

BOOL ZGInt8LessThan(COMPARISON_PARAMETERS)
{
	BOOL isLessThan = *((int8_t *)variableValue) < *((int8_t *)compareValue);
	if (searchData->_rangeValue && isLessThan)
	{
		isLessThan = *((int8_t *)variableValue) > *((int8_t *)searchData->_rangeValue);
	}
	return isLessThan;
}

BOOL ZGUInt8LessThan(COMPARISON_PARAMETERS)
{
	BOOL isLessThan = *((uint8_t *)variableValue) < *((uint8_t *)compareValue);
	if (searchData->_rangeValue && isLessThan)
	{
		isLessThan = *((uint8_t *)variableValue) > *((uint8_t *)searchData->_rangeValue);
	}
	return isLessThan;
}

BOOL ZGInt16LessThan(COMPARISON_PARAMETERS)
{
	BOOL isLessThan = *((int16_t *)variableValue) < *((int16_t *)compareValue);
	if (searchData->_rangeValue && isLessThan)
	{
		isLessThan = *((int16_t *)variableValue) > *((int16_t *)searchData->_rangeValue);
	}
	return isLessThan;
}

BOOL ZGUInt16LessThan(COMPARISON_PARAMETERS)
{
	BOOL isLessThan = *((uint16_t *)variableValue) < *((uint16_t *)compareValue);
	if (searchData->_rangeValue && isLessThan)
	{
		isLessThan = *((uint16_t *)variableValue) > *((uint16_t *)searchData->_rangeValue);
	}
	return isLessThan;
}

BOOL ZGInt32LessThan(COMPARISON_PARAMETERS)
{
	BOOL isLessThan = *((int32_t *)variableValue) < *((int32_t *)compareValue);
	if (searchData->_rangeValue && isLessThan)
	{
		isLessThan = *((int32_t *)variableValue) > *((int32_t *)searchData->_rangeValue);
	}
	return isLessThan;
}

BOOL ZGUInt32LessThan(COMPARISON_PARAMETERS)
{
	BOOL isLessThan = *((uint32_t *)variableValue) < *((uint32_t *)compareValue);
	if (searchData->_rangeValue && isLessThan)
	{
		isLessThan = *((uint32_t *)variableValue) > *((uint32_t *)searchData->_rangeValue);
	}
	return isLessThan;
}

BOOL ZGInt64LessThan(COMPARISON_PARAMETERS)
{
	BOOL isLessThan = *((int64_t *)variableValue) < *((int64_t *)compareValue);
	if (searchData->_rangeValue && isLessThan)
	{
		isLessThan = *((int64_t *)variableValue) > *((int64_t *)searchData->_rangeValue);
	}
	return isLessThan;
}

BOOL ZGUInt64LessThan(COMPARISON_PARAMETERS)
{
	BOOL isLessThan = *((uint64_t *)variableValue) < *((uint64_t *)compareValue);
	if (searchData->_rangeValue && isLessThan)
	{
		isLessThan = *((uint64_t *)variableValue) > *((uint64_t *)searchData->_rangeValue);
	}
	return isLessThan;
}

BOOL ZGFloatLessThan(COMPARISON_PARAMETERS)
{
	BOOL isLessThan = *((float *)variableValue) < *((float *)compareValue);
	if (searchData->_rangeValue && isLessThan)
	{
		isLessThan = *((float *)variableValue) > *((float *)searchData->_rangeValue);
	}
	return isLessThan;
}

BOOL ZGDoubleLessThan(COMPARISON_PARAMETERS)
{
	BOOL isLessThan = *((double *)variableValue) < *((double *)compareValue);
	if (searchData->_rangeValue && isLessThan)
	{
		isLessThan = *((double *)variableValue) > *((double *)searchData->_rangeValue);
	}
	return isLessThan;
}

#pragma mark Greater Than Functions

BOOL ZGInt8GreaterThan(COMPARISON_PARAMETERS)
{
	BOOL isGreaterThan = *((int8_t *)variableValue) > *((int8_t *)compareValue);
	if (searchData->_rangeValue && isGreaterThan)
	{
		isGreaterThan = *((int8_t *)variableValue) < *((int8_t *)searchData->_rangeValue);
	}
	return isGreaterThan;
}

BOOL ZGUInt8GreaterThan(COMPARISON_PARAMETERS)
{
	BOOL isGreaterThan = *((uint8_t *)variableValue) > *((uint8_t *)compareValue);
	if (searchData->_rangeValue && isGreaterThan)
	{
		isGreaterThan = *((uint8_t *)variableValue) < *((uint8_t *)searchData->_rangeValue);
	}
	return isGreaterThan;
}

BOOL ZGInt16GreaterThan(COMPARISON_PARAMETERS)
{
	BOOL isGreaterThan = *((int16_t *)variableValue) > *((int16_t *)compareValue);
	if (searchData->_rangeValue && isGreaterThan)
	{
		isGreaterThan = *((int16_t *)variableValue) < *((int16_t *)searchData->_rangeValue);
	}
	return isGreaterThan;
}

BOOL ZGUInt16GreaterThan(COMPARISON_PARAMETERS)
{
	BOOL isGreaterThan = *((uint16_t *)variableValue) > *((uint16_t *)compareValue);
	if (searchData->_rangeValue && isGreaterThan)
	{
		isGreaterThan = *((uint16_t *)variableValue) < *((uint16_t *)searchData->_rangeValue);
	}
	return isGreaterThan;
}

BOOL ZGInt32GreaterThan(COMPARISON_PARAMETERS)
{
	BOOL isGreaterThan = *((int32_t *)variableValue) > *((int32_t *)compareValue);
	if (searchData->_rangeValue && isGreaterThan)
	{
		isGreaterThan = *((int32_t *)variableValue) < *((int32_t *)searchData->_rangeValue);
	}
	return isGreaterThan;
}

BOOL ZGUInt32GreaterThan(COMPARISON_PARAMETERS)
{
	BOOL isGreaterThan = *((uint32_t *)variableValue) > *((uint32_t *)compareValue);
	if (searchData->_rangeValue && isGreaterThan)
	{
		isGreaterThan = *((uint32_t *)variableValue) < *((uint32_t *)searchData->_rangeValue);
	}
	return isGreaterThan;
}

BOOL ZGInt64GreaterThan(COMPARISON_PARAMETERS)
{
	BOOL isGreaterThan = *((int64_t *)variableValue) > *((int64_t *)compareValue);
	if (searchData->_rangeValue && isGreaterThan)
	{
		isGreaterThan = *((int64_t *)variableValue) < *((int64_t *)searchData->_rangeValue);
	}
	return isGreaterThan;
}

BOOL ZGUInt64GreaterThan(COMPARISON_PARAMETERS)
{
	BOOL isGreaterThan = *((uint64_t *)variableValue) > *((uint64_t *)compareValue);
	if (searchData->_rangeValue && isGreaterThan)
	{
		isGreaterThan = *((uint64_t *)variableValue) < *((uint64_t *)searchData->_rangeValue);
	}
	return isGreaterThan;
}

BOOL ZGFloatGreaterThan(COMPARISON_PARAMETERS)
{
	BOOL isGreaterThan = *((float *)variableValue) > *((float *)compareValue);
	if (searchData->_rangeValue && isGreaterThan)
	{
		isGreaterThan = *((float *)variableValue) < *((float *)searchData->_rangeValue);
	}
	return isGreaterThan;
}

BOOL ZGDoubleGreaterThan(COMPARISON_PARAMETERS)
{
	BOOL isGreaterThan = *((double *)variableValue) > *((double *)compareValue);
	if (searchData->_rangeValue && isGreaterThan)
	{
		isGreaterThan = *((double *)variableValue) < *((double *)searchData->_rangeValue);
	}
	return isGreaterThan;
}

#pragma mark Not Equal Functions

BOOL ZGInt8NotEquals(COMPARISON_PARAMETERS)
{
	return !ZGInt8Equals(NOT_EQUALS_CALLER_ARGUMENTS);
}

BOOL ZGInt16NotEquals(COMPARISON_PARAMETERS)
{
	return !ZGInt16Equals(NOT_EQUALS_CALLER_ARGUMENTS);
}

BOOL ZGInt32NotEquals(COMPARISON_PARAMETERS)
{
	return !ZGInt32Equals(NOT_EQUALS_CALLER_ARGUMENTS);
}

BOOL ZGInt64NotEquals(COMPARISON_PARAMETERS)
{
	return !ZGInt64Equals(NOT_EQUALS_CALLER_ARGUMENTS);
}

BOOL ZGFloatNotEquals(COMPARISON_PARAMETERS)
{
	return !ZGFloatEquals(NOT_EQUALS_CALLER_ARGUMENTS);
}

BOOL ZGDoubleNotEquals(COMPARISON_PARAMETERS)
{
	return !ZGDoubleEquals(NOT_EQUALS_CALLER_ARGUMENTS);
}

BOOL ZGString8NotEquals(COMPARISON_PARAMETERS)
{
	return !ZGString8Equals(NOT_EQUALS_CALLER_ARGUMENTS);
}

BOOL ZGString16NotEquals(COMPARISON_PARAMETERS)
{
	return !ZGString16Equals(NOT_EQUALS_CALLER_ARGUMENTS);
}

BOOL ZGByteArrayNotEquals(COMPARISON_PARAMETERS)
{
	return !ZGByteArrayEquals(NOT_EQUALS_CALLER_ARGUMENTS);
}

#pragma mark Equal Plus Functions

BOOL ZGInt8EqualsPlus(COMPARISON_PARAMETERS)
{
	int8_t newCompareValue = *((int8_t *)compareValue) + *((int8_t *)searchData->_compareOffset);
	return ZGInt8Equals(EQUALS_PLUS_CALLER_ARGUMENTS);
}

BOOL ZGInt16EqualsPlus(COMPARISON_PARAMETERS)
{
	int16_t newCompareValue = *((int16_t *)compareValue) + *((int16_t *)searchData->_compareOffset);
	return ZGInt16Equals(EQUALS_PLUS_CALLER_ARGUMENTS);
}

BOOL ZGInt32EqualsPlus(COMPARISON_PARAMETERS)
{
	int32_t newCompareValue = *((int32_t *)compareValue) + *((int32_t *)searchData->_compareOffset);
	return ZGInt32Equals(EQUALS_PLUS_CALLER_ARGUMENTS);
}

BOOL ZGInt64EqualsPlus(COMPARISON_PARAMETERS)
{
	int64_t newCompareValue = *((int64_t *)compareValue) + *((int64_t *)searchData->_compareOffset);
	return ZGInt64Equals(EQUALS_PLUS_CALLER_ARGUMENTS);
}

BOOL ZGFloatEqualsPlus(COMPARISON_PARAMETERS)
{
	float newCompareValue = *((float *)compareValue) + *((float *)searchData->_compareOffset);
	return ZGFloatEquals(EQUALS_PLUS_CALLER_ARGUMENTS);
}

BOOL ZGDoubleEqualsPlus(COMPARISON_PARAMETERS)
{
	double newCompareValue = *((double *)compareValue) + *((double *)searchData->_compareOffset);
	return ZGDoubleEquals(EQUALS_PLUS_CALLER_ARGUMENTS);
}

#pragma mark Not Equal Plus Functions

BOOL ZGInt8NotEqualsPlus(COMPARISON_PARAMETERS)
{
	return !ZGInt8EqualsPlus(NOT_EQUALS_CALLER_ARGUMENTS);
}

BOOL ZGInt16NotEqualsPlus(COMPARISON_PARAMETERS)
{
	return !ZGInt16EqualsPlus(NOT_EQUALS_CALLER_ARGUMENTS);
}

BOOL ZGInt32NotEqualsPlus(COMPARISON_PARAMETERS)
{
	return !ZGInt32EqualsPlus(NOT_EQUALS_CALLER_ARGUMENTS);
}

BOOL ZGInt64NotEqualsPlus(COMPARISON_PARAMETERS)
{
	return !ZGInt64EqualsPlus(NOT_EQUALS_CALLER_ARGUMENTS);
}

BOOL ZGFloatNotEqualsPlus(COMPARISON_PARAMETERS)
{
	return !ZGFloatEqualsPlus(NOT_EQUALS_CALLER_ARGUMENTS);
}

BOOL ZGDoubleNotEqualsPlus(COMPARISON_PARAMETERS)
{
	return !ZGDoubleEqualsPlus(NOT_EQUALS_CALLER_ARGUMENTS);
}

#pragma mark Grabbing Comparison Functions

comparison_function_t getEqualsComparisonFunction(ZGVariableType dataType, BOOL is64Bit)
{
	comparison_function_t comparisonFunction = NULL;
	
	switch (dataType)
	{
		case ZGInt8:
			comparisonFunction = ZGInt8Equals;
			break;
		case ZGInt16:
			comparisonFunction = ZGInt16Equals;
			break;
		case ZGInt32:
			comparisonFunction = ZGInt32Equals;
			break;
		case ZGInt64:
			comparisonFunction = ZGInt64Equals;
			break;
		case ZGFloat:
			comparisonFunction = ZGFloatEquals;
			break;
		case ZGDouble:
			comparisonFunction = ZGDoubleEquals;
			break;
		case ZGString8:
			comparisonFunction = ZGString8Equals;
			break;
		case ZGString16:
			comparisonFunction = ZGString16Equals;
			break;
		case ZGByteArray:
			comparisonFunction = ZGByteArrayEquals;
			break;
		case ZGPointer:
			comparisonFunction = is64Bit ? ZGInt64Equals : ZGInt32Equals;
			break;
		case ZGScript:
			break;
	}
	
	return comparisonFunction;
}

comparison_function_t getNotEqualsComparisonFunction(ZGVariableType dataType, BOOL is64Bit)
{
	comparison_function_t comparisonFunction = NULL;
	
	switch (dataType)
	{
		case ZGInt8:
			comparisonFunction = ZGInt8NotEquals;
			break;
		case ZGInt16:
			comparisonFunction = ZGInt16NotEquals;
			break;
		case ZGInt32:
			comparisonFunction = ZGInt32NotEquals;
			break;
		case ZGInt64:
			comparisonFunction = ZGInt64NotEquals;
			break;
		case ZGFloat:
			comparisonFunction = ZGFloatNotEquals;
			break;
		case ZGDouble:
			comparisonFunction = ZGDoubleNotEquals;
			break;
		case ZGString8:
			comparisonFunction = ZGString8NotEquals;
			break;
		case ZGString16:
			comparisonFunction = ZGString16NotEquals;
			break;
		case ZGByteArray:
			comparisonFunction = ZGByteArrayNotEquals;
			break;
		case ZGPointer:
			comparisonFunction = is64Bit ? ZGInt64NotEquals : ZGInt32NotEquals;
			break;
		case ZGScript:
			break;
	}
	
	return comparisonFunction;
}

comparison_function_t getLessThanComparisonFunction(ZGVariableType dataType, BOOL is64Bit, ZGVariableQualifier qualifier)
{
	comparison_function_t comparisonFunction = NULL;
	
	switch (dataType)
	{
		case ZGInt8:
			if (qualifier == ZGSigned)
			{
				comparisonFunction = ZGInt8LessThan;
			}
			else
			{
				comparisonFunction = ZGUInt8LessThan;
			}
			break;
		case ZGInt16:
			if (qualifier == ZGSigned)
			{
				comparisonFunction = ZGInt16LessThan;
			}
			else
			{
				comparisonFunction = ZGUInt16LessThan;
			}
			break;
		case ZGInt32:
			if (qualifier == ZGSigned)
			{
				comparisonFunction = ZGInt32LessThan;
			}
			else
			{
				comparisonFunction = ZGUInt32LessThan;
			}
			break;
		case ZGInt64:
			if (qualifier == ZGSigned)
			{
				comparisonFunction = ZGInt64LessThan;
			}
			else
			{
				comparisonFunction = ZGUInt64LessThan;
			}
			break;
		case ZGFloat:
			comparisonFunction = ZGFloatLessThan;
			break;
		case ZGDouble:
			comparisonFunction = ZGDoubleLessThan;
			break;
		case ZGString8:
			break;
		case ZGString16:
			break;
		case ZGPointer:
			comparisonFunction = is64Bit ? ZGUInt64LessThan : ZGUInt32LessThan;
			break;
		case ZGByteArray:
			break;
		case ZGScript:
			break;
	}
	
	return comparisonFunction;
}

comparison_function_t getGreaterThanComparisonFunction(ZGVariableType dataType, BOOL is64Bit, ZGVariableQualifier qualifier)
{
	comparison_function_t comparisonFunction = NULL;
	
	switch (dataType)
	{
		case ZGInt8:
			if (qualifier == ZGSigned)
			{
				comparisonFunction = ZGInt8GreaterThan;
			}
			else
			{
				comparisonFunction = ZGUInt8GreaterThan;
			}
			break;
		case ZGInt16:
			if (qualifier == ZGSigned)
			{
				comparisonFunction = ZGInt16GreaterThan;
			}
			else
			{
				comparisonFunction = ZGUInt16GreaterThan;
			}
			break;
		case ZGInt32:
			if (qualifier == ZGSigned)
			{
				comparisonFunction = ZGInt32GreaterThan;
			}
			else
			{
				comparisonFunction = ZGUInt32GreaterThan;
			}
			break;
		case ZGInt64:
			if (qualifier == ZGSigned)
			{
				comparisonFunction = ZGInt64GreaterThan;
			}
			else
			{
				comparisonFunction = ZGUInt64GreaterThan;
			}
			break;
		case ZGFloat:
			comparisonFunction = ZGFloatGreaterThan;
			break;
		case ZGDouble:
			comparisonFunction = ZGDoubleGreaterThan;
			break;
		case ZGString8:
			break;
		case ZGString16:
			break;
		case ZGPointer:
			comparisonFunction = is64Bit ? ZGUInt64GreaterThan : ZGUInt32GreaterThan;
			break;
		case ZGByteArray:
			break;
		case ZGScript:
			break;
	}
	
	return comparisonFunction;
}

comparison_function_t getEqualsStoredPlusComparisonFunction(ZGVariableType dataType, BOOL is64Bit)
{
	comparison_function_t comparisonFunction = NULL;
	
	switch (dataType)
	{
		case ZGInt8:
			comparisonFunction = ZGInt8EqualsPlus;
			break;
		case ZGInt16:
			comparisonFunction = ZGInt16EqualsPlus;
			break;
		case ZGInt32:
			comparisonFunction = ZGInt32EqualsPlus;
			break;
		case ZGInt64:
			comparisonFunction = ZGInt64EqualsPlus;
			break;
		case ZGFloat:
			comparisonFunction = ZGFloatEqualsPlus;
			break;
		case ZGDouble:
			comparisonFunction = ZGDoubleEqualsPlus;
			break;
		case ZGString8:
			break;
		case ZGString16:
			break;
		case ZGByteArray:
			break;
		case ZGPointer:
			comparisonFunction = is64Bit ? ZGInt64EqualsPlus : ZGInt32EqualsPlus;
			break;
		case ZGScript:
			break;
	}
	
	return comparisonFunction;
}

comparison_function_t getNotEqualsStoredPlusComparisonFunction(ZGVariableType dataType, BOOL is64Bit)
{
	comparison_function_t comparisonFunction = NULL;
	
	switch (dataType)
	{
		case ZGInt8:
			comparisonFunction = ZGInt8NotEqualsPlus;
			break;
		case ZGInt16:
			comparisonFunction = ZGInt16NotEqualsPlus;
			break;
		case ZGInt32:
			comparisonFunction = ZGInt32NotEqualsPlus;
			break;
		case ZGInt64:
			comparisonFunction = ZGInt64NotEqualsPlus;
			break;
		case ZGFloat:
			comparisonFunction = ZGFloatNotEqualsPlus;
			break;
		case ZGDouble:
			comparisonFunction = ZGDoubleNotEqualsPlus;
			break;
		case ZGString8:
			break;
		case ZGString16:
			break;
		case ZGByteArray:
			break;
		case ZGPointer:
			comparisonFunction = is64Bit ? ZGInt64NotEqualsPlus : ZGInt32NotEqualsPlus;
			break;
		case ZGScript:
			break;
	}
	
	return comparisonFunction;
}

comparison_function_t getComparisonFunction(ZGFunctionType functionType, ZGVariableType dataType, BOOL is64Bit, ZGVariableQualifier qualifier)
{
	comparison_function_t comparisonFunction = NULL;
	
	switch (functionType)
	{
		case ZGEquals:
		case ZGEqualsStored:
			comparisonFunction = getEqualsComparisonFunction(dataType, is64Bit);
			break;
		case ZGNotEquals:
		case ZGNotEqualsStored:
			comparisonFunction = getNotEqualsComparisonFunction(dataType, is64Bit);
			break;
		case ZGLessThan:
		case ZGLessThanStored:
			comparisonFunction = getLessThanComparisonFunction(dataType, is64Bit, qualifier);
			break;
		case ZGGreaterThan:
		case ZGGreaterThanStored:
			comparisonFunction = getGreaterThanComparisonFunction(dataType, is64Bit, qualifier);
			break;
		case ZGEqualsStoredPlus:
			comparisonFunction = getEqualsStoredPlusComparisonFunction(dataType, is64Bit);
			break;
		case ZGNotEqualsStoredPlus:
			comparisonFunction = getNotEqualsStoredPlusComparisonFunction(dataType, is64Bit);
			break;
		case ZGStoreAllValues:
			break;
	}
	
	return comparisonFunction;
}
