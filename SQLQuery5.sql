 select *
from NashvilleHousing


select SaleDate, convert(date, SaleDate) as convertedSaleDate
from NashvilleHousing


update NashvilleHousing
set SaleDate = convert(Date, SaleDate)

--Populate Property Address Data

select *
from NashvilleHousing
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	 
	--Breaking out address into individual columns (Address, City, State)

select PropertyAddress
from NashvilleHousing


	select
	substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1) as Address,
		substring(PropertyAddress, charindex(',', PropertyAddress), Len(PropertyAddress)) as Address
	from NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress nvarchar(255)

update NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1)


alter table NashvilleHousing
add PropertySplitCity nvarchar(255)

update NashvilleHousing
set PropertySplitCity = substring(PropertyAddress, charindex(',', PropertyAddress), Len(PropertyAddress))

select *
from NashvilleHousing

select OwnerAddress
from NashvilleHousing

select 
PARSENAME (replace(OwnerAddress, ',', '.'), 3),
PARSENAME (replace(OwnerAddress, ',', '.'), 2),
PARSENAME (replace(OwnerAddress, ',', '.'), 1)
from NashvilleHousing

alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255)

update NashvilleHousing
set OwnerSplitAddress = PARSENAME (replace(OwnerAddress, ',', '.'), 3)


alter table NashvilleHousing
add OwnerSplitCity nvarchar(255)

update NashvilleHousing
set OwnerSplitCity = PARSENAME (replace(OwnerAddress, ',', '.'), 2)

alter table NashvilleHousing
add OwnerSplitState nvarchar(255)

update NashvilleHousing
set OwnerSplitState = PARSENAME (replace(OwnerAddress, ',', '.'), 1)


select *
from NashvilleHousing


--change Y and N to Yes and No in "sold as vacant field

select distinct(SoldAsVacant), count(SoldAsVacant)
from NashvilleHousing 
group by SoldAsVacant
order by 2

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end

--Remove Duplicates

with RowNumCTE as(
select *,
row_number() over (
partition by ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 order by UniqueID
) row_num

from NashvilleHousing
)
Delete
from RowNumCTE
where row_num > 1
--order by PropertyAddress


--Delete Unused Columns

select *
from NashvilleHousing

alter table NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table NashvilleHousing
drop column SaleDate