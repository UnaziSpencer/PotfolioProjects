Select *
from PortfolioProject..NashvilleHousing

--Standandize date format

select saledateConverted, CONVERT(Date,Saledate)
from PortfolioProject..NashvilleHousing

update NashvilleHousing
set SaleDate = CONVERT(Date,Saledate)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = CONVERT(Date,Saledate)

--Populate property address data

selecT *
from PortfolioProject..NashvilleHousing
--where propertyAddress is null
order by ParcelID


SelecT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b   
On a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
Set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b   
On a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out address into individual colunms (Address, city, state)


selecT PropertyAddress
from PortfolioProject..NashvilleHousing
--where propertyAddress is null
--order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

from PortfolioProject..NashvilleHousing


Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


Select *
from PortfolioProject..NashvilleHousing

Select OwnerAddress
FROM PortfolioProject..NashvilleHousing


Select 
parsename(Replace(OwnerAddress, ',', ',') , 3)
,parsename(Replace(OwnerAddress, ',', ',') , 2)
,parsename(Replace(OwnerAddress, ',', ',') , 1)
from PortfolioProject..NashvilleHousing


Alter Table NashvilleHousing
Add OwnerSliptAddress Nvarchar(255);

update NashvilleHousing
set OwnerSliptAddress = Parsename(Replace(OwnerAddress, ',', ',') , 3)


Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

update NashvilleHousing
set OwnerSplitCity = parsename(Replace(OwnerAddress, ',', ',') , 2)

Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

update NashvilleHousing
set OwnerSplitState = parsename(Replace(OwnerAddress, ',', ',') , 1)


-- Change Yand N to Yes and NO in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, Case When SoldAsVacant = 'Y' THEN 'Yes' 
	   When SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   End
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' THEN 'Yes' 
	   When SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   End

	   Select *
	   from PortfolioProject..NashvilleHousing

	   --Remove Duplicate

With RowNumCTE AS(
Select *,
	  Row_Number() Over (
	  Partition By ParcelID,
		           PropertyAddress, 
				   SalePrice,
				   SaleDate,
				   LegalReference
				   Order By
						UniqueID
						  ) row_num

from PortfolioProject..NashvilleHousing
Delete
From RowNumCTE
Where row_num > 1
order by propertyAddress
        