use PortfolioProject
select * from Sheet1$
-----------------------------------------------------------------------------------------------------------------
---Standardize Date Format

select saledateconverted , convert (date,saledate) 
from Sheet1$


select saledateconverted from Sheet1$

alter table sheet1$
add SaleDateConverted Date;


update Sheet1$
set SaleDateConverted = convert (date,saledate),

-----Populate Property Address Data

select * from Sheet1$
--where PropertyAddress is null
order by ParcelID

select a.ParcelID , a.PropertyAddress , b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from Sheet1$ a
join Sheet1$ b
  on a.ParcelID = b.ParcelID 
  and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


update a
set PropertyAddress =ISNULL(a.PropertyAddress,b.PropertyAddress)
from Sheet1$ a
join Sheet1$ b
  on a.ParcelID = b.ParcelID 
  and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

-----Breaking out address into individual coloumn (address, city , state )

select PropertyAddress
from Sheet1$


select 
substring(PropertyAddress, 1, Charindex(',', propertyAddress)-1) as addresss,
substring(PropertyAddress, Charindex(',', propertyAddress) +1 , LEN(PropertyAddress)) as addresss
from Sheet1$


Alter table sheet1$
add propertysplitaddress nvarchar(255);

update  Sheet1$
set   propertysplitaddress= substring(PropertyAddress, 1, Charindex(',', propertyAddress)-1)


Alter table sheet1$
add PropertySplitCity nvarchar(255);

update  Sheet1$
set   PropertySplitCity = substring(PropertyAddress, Charindex(',', propertyAddress) +1 , LEN(PropertyAddress))

------------------------------------------------------------------------------------
Select OwnerAddress
From Sheet1$


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Sheet1$


ALTER TABLE Sheet1$
Add OwnerSplitAddress Nvarchar(255);

Update Sheet1$
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Sheet1$
Add OwnerSplitCity Nvarchar(255);

Update Sheet1$
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Sheet1$
Add OwnerSplitState Nvarchar(255);

Update Sheet1$
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From Sheet1$
------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Sheet1$
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Sheet1$


Update Sheet1$
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

----------------------------------------------------------------------------------------------------------
-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Sheet1$
--order by ParcelID
)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

--delete
--From RowNumCTE
--Where row_num > 1
----Order by PropertyAddress

Select *
From Sheet1$


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From Sheet1$


ALTER TABLE sheet1$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate






