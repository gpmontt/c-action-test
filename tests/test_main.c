/**
 * @file test_main.c
 * @brief Unit tests for main application functions
 */

#include "unity.h"
#include "utils.h"

/* Unity test framework setup and teardown */
void setUp(void)
{
    /* Called before each test */
}

void tearDown(void)
{
    /* Called after each test */
}

/* Test cases for add_numbers function */
void test_add_numbers_positive(void)
{
    TEST_ASSERT_EQUAL_UINT32(5, add_numbers(2, 3));
    TEST_ASSERT_EQUAL_UINT32(100, add_numbers(50, 50));
    TEST_ASSERT_EQUAL_UINT32(1000000, add_numbers(500000, 500000));
}

void test_add_numbers_zero(void)
{
    TEST_ASSERT_EQUAL_UINT32(0, add_numbers(0, 0));
    TEST_ASSERT_EQUAL_UINT32(42, add_numbers(42, 0));
    TEST_ASSERT_EQUAL_UINT32(42, add_numbers(0, 42));
}

void test_add_numbers_large(void)
{
    TEST_ASSERT_EQUAL_UINT32(0xFFFFFFFF, add_numbers(0xFFFFFFFF, 0));
    TEST_ASSERT_EQUAL_UINT32(0x80000000, add_numbers(0x40000000, 0x40000000));
}

/* Test cases for is_valid_temperature function */
void test_temperature_valid_range(void)
{
    TEST_ASSERT_TRUE(is_valid_temperature(0));
    TEST_ASSERT_TRUE(is_valid_temperature(25));
    TEST_ASSERT_TRUE(is_valid_temperature(-40));
    TEST_ASSERT_TRUE(is_valid_temperature(85));
    TEST_ASSERT_TRUE(is_valid_temperature(20));
}

void test_temperature_invalid_too_low(void)
{
    TEST_ASSERT_FALSE(is_valid_temperature(-41));
    TEST_ASSERT_FALSE(is_valid_temperature(-100));
    TEST_ASSERT_FALSE(is_valid_temperature(-50));
}

void test_temperature_invalid_too_high(void)
{
    TEST_ASSERT_FALSE(is_valid_temperature(86));
    TEST_ASSERT_FALSE(is_valid_temperature(100));
    TEST_ASSERT_FALSE(is_valid_temperature(200));
}

void test_temperature_boundary_values(void)
{
    TEST_ASSERT_TRUE(is_valid_temperature(-40));  /* Lower boundary */
    TEST_ASSERT_TRUE(is_valid_temperature(85));   /* Upper boundary */
    TEST_ASSERT_FALSE(is_valid_temperature(-41)); /* Just below lower */
    TEST_ASSERT_FALSE(is_valid_temperature(86));  /* Just above upper */
}

/* Main test runner */
int main(void)
{
    UNITY_BEGIN();
    
    /* Run add_numbers tests */
    RUN_TEST(test_add_numbers_positive);
    RUN_TEST(test_add_numbers_zero);
    RUN_TEST(test_add_numbers_large);
    
    /* Run temperature validation tests */
    RUN_TEST(test_temperature_valid_range);
    RUN_TEST(test_temperature_invalid_too_low);
    RUN_TEST(test_temperature_invalid_too_high);
    RUN_TEST(test_temperature_boundary_values);
    
    return UNITY_END();
}
